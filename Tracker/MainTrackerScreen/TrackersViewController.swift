//
//  TrackerScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 06.12.2023.
//

import UIKit
import SnapKit
import YandexMobileMetrica

protocol TrackersViewDelegate : AnyObject {
    
    func createTracker(tracker: TrackerModel, name: String)
    
    func change(tracker: TrackerModel , name: String)
}

protocol TrackerViewCellDelegate : AnyObject {
    
    func completeTraker(_ record : TrackerRecord)
    
    func uncompleteTracker(_ record : TrackerRecord)
    
    func deleteTracker(_ id: UUID)
    
    func pinTracker(_ id: UUID)
    
    func unPinTracker(_ id : UUID)
    
    func changeTracker(_ id: UUID)
}

protocol FilterViewDelegate: AnyObject {
    
    func didSelectFilter(_ filter: String)
    
    func didDeselectFilter()
}

final class TrackersViewController : UIViewController {
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var filterTrackers : [TrackerCategory] = []
    
    private var currentDate = Date()
    
    private var search = UISearchController()
    
    private var categories : [TrackerCategory] = []
    
    private var trackerStore = TrackerStore()
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    private var trackerRecordStore = TrackerRecordStore.shared
    
    private var filterValue = NSLocalizedString("Все трекеры", comment: "")
    
    private var collectionView : UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor(named: "White")
        collection.contentInset = UIEdgeInsets(top: 6, left: 16, bottom: 24, right: 16)
        return collection
    }()
    
    private lazy var datePicker : UIDatePicker = {
        var picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        picker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        return picker
    }()
    
    private var emptyLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.font = TrackerFont.medium12
        return label
    }()
    
    private var emptyImageView : UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        button.setTitle(NSLocalizedString("Filters", comment: ""), for: .normal)
        button.titleLabel?.font = TrackerFont.regular17
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapOnFilterButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = trackerCategoryStore.returnCategory()
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerViewCellHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "head")
        collectionView.dataSource = self
        collectionView.delegate = self
        search.searchBar.delegate = self
        setupScreen()
        completedTrackers = trackerRecordStore.returnTrackersRecord()
        filterCategories(Date())
        YMMYandexMetrica.reportEvent("Main view didload", parameters: ["event": "open", "screen": "Main"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    @objc private func tapAddButton(){
        YMMYandexMetrica.reportEvent("tap create tracker button", parameters: ["event": "click", "screen": "Main", "item": "tapButton"])
        let createTrackerScreen =  CreateTrackerView()
        createTrackerScreen.delegate = self
        present(UINavigationController(rootViewController: createTrackerScreen), animated: true)
    }
    
    @objc private func changeDate(){
        YMMYandexMetrica.reportEvent("Change date action", parameters: ["event": "change", "screen": "Main"])
        currentDate = datePicker.date
        filterCategories(currentDate)
    }
    
    @objc private func tapOnFilterButton(){
        YMMYandexMetrica.reportEvent("press filter button", parameters: ["event": "click", "screen": "Main", "item": "filter"])
        let filterView = FilterViewController()
        filterView.delegate = self
        filterView.setCurrentFilter(filterValue)
        present(filterView, animated: true)
    }
    
    private func setupScreen(){
        title = NSLocalizedString("Трекеры", comment: "")
        [collectionView,
         emptyImageView,
         emptyLabel,
         filterButton].forEach { view.addSubview($0)}
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
        }
        emptyImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.centerX.centerY.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp_bottomMargin).offset(8)
            $0.centerX.equalToSuperview()
        }
        filterButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(114)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        navigationItem.searchController = search
        search.searchBar.placeholder = NSLocalizedString("Поиск", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddTracker"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapAddButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Black")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(95)
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func showOrHideLabelWithImage(){
        emptyLabel.text = NSLocalizedString("Что будем отслеживать?", comment: "")
        emptyImageView.image = UIImage(named: "star")
        let result = filterTrackers.filter {$0.header != ""}
        if result.isEmpty {
            emptyLabel.isHidden = false
            emptyImageView.isHidden = false
        } else {
            emptyLabel.isHidden = true
            emptyImageView.isHidden = true
        }
    }
    
    private func showOrHideLabelWithImageSearch(){
        emptyLabel.text = NSLocalizedString("ничего не найдено", comment: "")
        emptyImageView.image = UIImage(named: "foundError")
        let result = filterTrackers.filter {$0.header != ""}
        if result.isEmpty {
            emptyLabel.isHidden = false
            emptyImageView.isHidden = false
        } else {
            emptyLabel.isHidden = true
            emptyImageView.isHidden = true
        }
    }
    
    private func filterCategories(_ date : Date) {
        filterTrackers = []
        var selectedWeekday = Calendar.current.component(.weekday, from: date)
        for i in 0..<categories.count {
            var trackers = categories[i].trackers
            trackers = trackers.filter {
                if filterValue == NSLocalizedString("Завершенные", comment: "") {
                    return $0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday) && trackerRecordStore.completedToday(id: $0.id, date: currentDate)
                } else if filterValue == NSLocalizedString("Не завершенные", comment: "") {
                    return !($0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday) && trackerRecordStore.completedToday(id: $0.id, date: currentDate))
                } else if filterValue == NSLocalizedString("Трекеры на сегодня", comment: "") {
                    selectedWeekday = Calendar.current.component(.weekday, from: Date())
                    return $0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday)
                }
                return $0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday)
            }
            if !trackers.isEmpty {
                filterTrackers.append(TrackerCategory(header:  categories[i].header, trackers: trackers))
            }
        }
        if filterValue == NSLocalizedString("Трекеры на сегодня", comment: "") {
            datePicker.date = Date()
            filterValue = NSLocalizedString("Все трекеры", comment: "")
        }
        showOrHideLabelWithImage()
        collectionView.reloadData()
    }
    
    private func filterSearch(text : String){
        filterTrackers = []
        for i in 0..<categories.count {
            var trackers = categories[i].trackers
            trackers = trackers.filter {
                let textOne = $0.name.lowercased()
                let textTwo = text.lowercased()
                return textOne.contains(textTwo)
            }
            if !trackers.isEmpty {
                filterTrackers.append(TrackerCategory(header:  categories[i].header, trackers: trackers))
            }
        }
        showOrHideLabelWithImageSearch()
        collectionView.reloadData()
    }
}

extension TrackersViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerViewCell
        let model = filterTrackers[indexPath.section].trackers[indexPath.row]
        cell?.delegate = self
        cell?.date = datePicker.date
        let completedDays = completedTrackers.filter { $0.id == model.id }.count
        let completedToday = completedTrackers.contains {
            $0.id == model.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        cell?.config(model: model, completedCount: completedDays,completedToday: completedToday)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head", for: indexPath) as? TrackerViewCellHeader
        view?.update(title: filterTrackers[indexPath.section].header)
        return view ?? UICollectionReusableView()
    }
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 148
        let width : CGFloat = 167
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}
extension TrackersViewController : TrackersViewDelegate {
    
    func createTracker(tracker: TrackerModel, name: String) {
        YMMYandexMetrica.reportEvent("create tracker", parameters: ["event": "create", "screen": "Main"])
        trackerStore.saveTrackerCoreData(tracker, name)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
    func change(tracker: TrackerModel , name: String) {
        YMMYandexMetrica.reportEvent("change tracker", parameters: ["event": "change", "screen": "Main"])
        trackerStore.changeTracker(tracker, name)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
}


extension TrackersViewController : TrackerViewCellDelegate {
    
    func deleteTracker(_ id: UUID) {
        YMMYandexMetrica.reportEvent("delete tracker", parameters: ["event": "delete", "screen": "Main","item": "delete"])
        trackerStore.deleteTracker(id)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
    
    func pinTracker(_ id: UUID) {
        YMMYandexMetrica.reportEvent("pin tracker", parameters: ["event": "pin", "screen": "Main","item": "pin"])
        trackerStore.pinTracker(id: id)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
    
    func unPinTracker(_ id: UUID) {
        YMMYandexMetrica.reportEvent("unpin tracker", parameters: ["event": "unPin", "screen": "Main","item": "unpin"])
        trackerStore.unPinTracker(id: id)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
    
    func changeTracker(_ id: UUID) {
        YMMYandexMetrica.reportEvent("present change tracker view", parameters: ["event": "tap", "screen": "Main","item": "edit"])
        guard let tracker = trackerStore.convertToTrackerData(id: id) else {
            return
        }
        let view = NewHabit()
        view.delegate = self
        view.regularIventSetup(tracker.regular)
        view.changeModeActive(id: id)
        present(view, animated: true)
    }
    
    func completeTraker(_ record: TrackerRecord) {
        YMMYandexMetrica.reportEvent("complete tracker", parameters: ["event": "tap", "screen": "Main"])
        trackerRecordStore.addRecord(trackerRecord: record)
        completedTrackers = trackerRecordStore.returnTrackersRecord()
        filterCategories(currentDate)
    }
    
    func uncompleteTracker(_ record: TrackerRecord) {
        YMMYandexMetrica.reportEvent("uncomplete tracker", parameters: ["event": "tap", "screen": "Main"])
        trackerRecordStore.removeRecord(trackerRecord: record)
        completedTrackers = trackerRecordStore.returnTrackersRecord()
        filterCategories(currentDate)
    }
}
extension TrackersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let searchText = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        filterSearch(text: searchText)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCategories(currentDate)
    }
}

extension TrackersViewController : FilterViewDelegate {
    func didSelectFilter(_ filter: String) {
        filterValue = filter
        filterCategories(currentDate)
    }
    
    func didDeselectFilter() {
        filterValue = NSLocalizedString("Все трекеры", comment: "")
        filterCategories(currentDate)
    }
    
    
}
