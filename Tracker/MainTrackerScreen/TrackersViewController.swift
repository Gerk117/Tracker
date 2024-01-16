//
//  TrackerScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 06.12.2023.
//

import UIKit
import SnapKit

protocol TrackersViewDelegate : AnyObject {
    func createTracker(tracker:TrackerModel)
}

class TrackersViewController : UIViewController {
    var completedTrackers: [TrackerRecord] = [TrackerRecord]()
    var currentDate: Date = .init()
    
    private var search = UISearchController()
    private var categories : [TrackerCategory] = [TrackerCategory(header: "Тестовый вариант", trackers: [TrackerModel(id: 0, name: "lol", colorName: UIColor.red, emoji: "", dates: [Date()]),
                                                                                             TrackerModel(id: 1, name: "lel", colorName: UIColor.blue, emoji: "", dates: [Date()])])]
    
    private var imageView : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private var datePicker : UIDatePicker = {
        var picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.layer.cornerRadius = 8
        picker.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return picker
    }()
    private var label : UILabel = {
        var label = UILabel()
        label.text = "что будем отслеживать?"
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.font = TrackerFont.medium12
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "head")
        collectionView.dataSource = self
        collectionView.delegate = self
        setupScreen()
    }
    
    @objc private func tapAddButton(){
        let createTrackerScreen =  CreateTrackerView()
        createTrackerScreen.delegate = self
        present(UINavigationController(rootViewController: createTrackerScreen), animated: true)
    }
    private func setupScreen(){
        title = "Трекеры"
        [collectionView,
         imageView,
         label].forEach { view.addSubview($0)}
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-330)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(8)
            make.centerX.equalToSuperview()
        }
        navigationItem.searchController = search
        search.searchBar.placeholder = "Поиск"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(tapAddButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(95)
        }
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension TrackersViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerViewCell
        let model = categories[indexPath.section].trackers[indexPath.row]
        cell?.config(model: model)
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head", for: indexPath) as? TrackerViewCellHeader
        view?.setup(title: categories[indexPath.section].header)
        return view ?? UICollectionReusableView()
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
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
    func createTracker(tracker: TrackerModel) {
        
    }
}

