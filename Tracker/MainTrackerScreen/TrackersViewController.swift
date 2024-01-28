//
//  TrackerScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 06.12.2023.
//

import UIKit
import SnapKit

protocol TrackersViewDelegate : AnyObject {
    func createTracker(tracker:TrackerCategory)
}
protocol TrackerViewCellDelegate : AnyObject {
    
    func completeTraker(_ record : TrackerRecord)
    
    func uncompleteTracker(_ record : TrackerRecord)
}

final class TrackersViewController : UIViewController {
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var filterTrackers : [TrackerCategory] = []
    
    private var currentDate = Date()
    
    private var search = UISearchController()
    
    private var categories : [TrackerCategory] = []
    
    private var trackerStore = TrackerStore()
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    private var trackerRecordStore = TrackerRecordStore()
    
    
    private var collectionView : UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        picker.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        picker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        return picker
    }()
    
    private var emptyLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.font = TrackerFont.medium12
        return label
    }()
    
    private var emptyImageView : UIImageView = {
        var image = UIImageView()
        return image
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
    }
    
    @objc private func tapAddButton(){
        let createTrackerScreen =  CreateTrackerView()
        createTrackerScreen.delegate = self
        present(UINavigationController(rootViewController: createTrackerScreen), animated: true)
    }
    
    @objc private func changeDate(){
        currentDate = datePicker.date
        filterCategories(currentDate)
    }
    
    private func setupScreen(){
        title = "Трекеры"
        [collectionView,
         emptyImageView,
         emptyLabel].forEach { view.addSubview($0)}
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
        navigationItem.searchController = search
        search.searchBar.placeholder = "Поиск"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddTracker"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapAddButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
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
        emptyLabel.text = "что будем отслеживать?"
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
        emptyLabel.text = "ничего не найдено"
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
        let selectedWeekday = Calendar.current.component(.weekday, from: date)
        for i in 0..<categories.count {
            var trackers = categories[i].trackers
            trackers = trackers.filter {
                $0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday)
            }
            if !trackers.isEmpty {
                filterTrackers.append(TrackerCategory(header:  categories[i].header, trackers: trackers))
            }
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
    func createTracker(tracker: TrackerCategory) {
        trackerCategoryStore.addCategory(tracker)
        categories = trackerCategoryStore.returnCategory()
        filterCategories(currentDate)
    }
}


extension TrackersViewController : TrackerViewCellDelegate {
    func completeTraker(_ record: TrackerRecord) {
        trackerRecordStore.addRecord(trackerRecord: record)
        completedTrackers = trackerRecordStore.returnTrackersRecord()
        filterCategories(currentDate)
    }
    
    func uncompleteTracker(_ record: TrackerRecord) {
//        print(currentDate)
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
