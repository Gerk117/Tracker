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

class TrackersViewController : UIViewController {
    var completedTrackers: [TrackerRecord] = []
    var filterTrackers : [TrackerCategory] = []
    private var currentDate = Date()
    private var search = UISearchController()
    private var categories : [TrackerCategory] =
    [TrackerCategory(header: "Тестовый вариант",
                     trackers: [TrackerModel(id: UUID(),
                                             name: "lol",
                                             colorName: UIColor.red,
                                             emoji: "",
                                             schedule: [WeekDay.friday,
                                                        WeekDay.monday,
                                                        WeekDay.sunday]),
                                TrackerModel(id: UUID(),
                                             name: "leaaal",
                                             colorName: UIColor.purple,
                                             emoji: "",
                                             schedule: [WeekDay.sunday,
                                                        WeekDay.saturday,
                                                        WeekDay.tuesday])]),
     TrackerCategory(header: "Tecтовый вариант 2 ",
                     trackers: [TrackerModel(id: UUID(),
                                             name: "kek",
                                             colorName: UIColor.purple,
                                             emoji: "",
                                             schedule: [WeekDay.sunday,
                                                        WeekDay.friday,
                                                        WeekDay.saturday]),
                                TrackerModel(id: UUID(),
                                             name: "lel",
                                             colorName: UIColor.blue,
                                             emoji: "",
                                             schedule: [WeekDay.sunday,
                                                        WeekDay.thursday,
                                                        WeekDay.wednesday])])]
    
    private var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout.init())
    
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
        label.text = "что будем отслеживать?"
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.font = TrackerFont.medium12
        return label
    }()
    private var emptyImageView : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerViewCellHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "head")
        collectionView.dataSource = self
        collectionView.delegate = self
        search.searchBar.delegate = self
        setupScreen()
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
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        emptyImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.centerX.centerY.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp_bottomMargin).offset(8)
            make.centerX.equalToSuperview()
        }
        navigationItem.searchController = search
        search.searchBar.placeholder = "Поиск"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddTracker"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapAddButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(95)
        }
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func showOrHideLabelWithImage(){
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
        filterTrackers = categories
        let selectedWeekday = Calendar.current.component(.weekday, from: date)
        filterTrackers = filterTrackers.map({
            var trackers = $0.trackers
            trackers = trackers.filter {
                $0.schedule.contains(WeekDay(rawValue: selectedWeekday) ?? .monday)
            }
            if trackers.isEmpty {
                return TrackerCategory(header: "" , trackers: trackers)
            } else {
                return TrackerCategory(header: $0.header , trackers: trackers)
            }
        })
        showOrHideLabelWithImage()
        collectionView.reloadData()
    }
    private func filterSearch(_ date : Date,text : String){
        filterTrackers = categories
        filterTrackers = filterTrackers.map({
            var trackers = $0.trackers
            trackers = trackers.filter {
                let textOne = $0.name.lowercased()
                let textTwo = text.lowercased()
                return textOne.contains(textTwo)
            }
            if trackers.isEmpty {
                return TrackerCategory(header: "" , trackers: trackers)
            } else {
                return TrackerCategory(header: $0.header , trackers: trackers)
            }
        })
        showOrHideLabelWithImage()
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
        view?.setup(title: filterTrackers[indexPath.section].header)
        return view ?? UICollectionReusableView()
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if filterTrackers[section].header == ""{
            return CGSize()
        } else {
            return CGSize(width: collectionView.bounds.width, height: 46)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 148
        let width : CGFloat = 167
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
extension TrackersViewController : TrackersViewDelegate {
    func createTracker(tracker: TrackerCategory) {
        for i in 0..<categories.count {
            if categories[i].header == tracker.header {
                categories[i] = TrackerCategory(header: tracker.header, trackers: tracker.trackers + categories[i].trackers)
                filterCategories(currentDate)
                return
            }
        }
        categories.append(tracker)
        filterCategories(currentDate)
    }
}


extension TrackersViewController : TrackerViewCellDelegate {
    func completeTraker(_ record: TrackerRecord) {
        completedTrackers.append(record)
        filterCategories(currentDate)
    }
    
    func uncompleteTracker(_ record: TrackerRecord) {
        completedTrackers.removeAll { trackerRecord in
            if (trackerRecord.id == record.id &&  Calendar.current.isDate(trackerRecord.date, equalTo: currentDate, toGranularity: .day)) {
                return true
            } else {
                return false
            }
        }
        filterCategories(currentDate)
    }
}
extension TrackersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let searchText = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        filterSearch(currentDate, text: searchText)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCategories(currentDate)
    }
    
    
}
