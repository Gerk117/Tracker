//
//  New.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 21.12.2023.
//

import UIKit
import SnapKit

protocol NewHabitCategoryDelegate : AnyObject {
    func category(titleForCategory : String)
}
protocol NewHabitSheduleDelegate : AnyObject {
    func shedule(weekDays : [WeekDay], titleForShedule : String)
}

final class NewHabit : UIViewController {
    
    private var namesOfCell : [String]!
    
    private var regularIvent : Bool!
    
    weak var delegate : TrackersViewDelegate?
    
    private var weekDays = [WeekDay]()
    
    private var nameOfCategory : String?
    
    private var sheduleTitle : String?
    
    private var selectedColor : IndexPath?
    
    private var selectedEmoji : IndexPath?
    
    private var emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private var colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3,
        .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9,
        .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15,
        .colorSelection16, .colorSelection17, .colorSelection18]
    
    private lazy var nameOfNewTracker : UITextField = {
        var text = UITextField()
        text.clipsToBounds = true
        text.clearButtonMode = .whileEditing
        text.delegate = self
        text.placeholder = "Введите название трекера"
        return text
    }()
    
    private var textView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var cancelButton : UIButton = {
        var button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var scrollView = UIScrollView()
    
    private lazy var acceptButton : UIButton = {
        var button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(createTracker), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return button
    }()
    
    private var mainStackView : UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private var buttonStackView : UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var table : UITableView = {
        var table = UITableView()
        table.tableHeaderView = UIView()
        table.rowHeight = 75
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.separatorColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return table
    }()
    
    private var errorLabel : UILabel = {
        var label = UILabel()
        label.text = "Ограничение 38 символов"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        label.font = TrackerFont.regular17
        return label
    }()
    
    private var colorAndEmojiCollectionView : UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        return collection
    }()
    
    func regularIventSetup(_ value : Bool){
        regularIvent = value
    }
    
    @objc private func createTracker(){
        guard let name = nameOfNewTracker.text else {
            return
        }
        guard !weekDays.isEmpty else {
            return
        }
        guard let nameOfCategory else {
            return
        }
        guard let selectedColor else {
            return
        }
        guard let selectedEmoji else {
            return
        }
        let tracker = TrackerModel(id: UUID(),
                                   name: name,
                                   colorName: colors[selectedColor.row],
                                   emoji: "\(emojis[selectedEmoji.row])",
                                   schedule: weekDays)
        let trackerCategory = TrackerCategory(header: nameOfCategory, trackers: [tracker])
        delegate?.createTracker(tracker: trackerCategory)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(NewHabitCell.self, forCellReuseIdentifier: "newHabitCell")
        table.dataSource = self
        table.delegate = self
        colorAndEmojiCollectionView.register(ColorsAndEmojisCell.self, forCellWithReuseIdentifier: "colorsAndEmojiCell")
        colorAndEmojiCollectionView.register(ColorsAndEmojisHeader.self,
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "head")
        colorAndEmojiCollectionView.dataSource = self
        colorAndEmojiCollectionView.delegate = self
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !nameOfNewTracker.text!.isEmpty,
           nameOfCategory != nil,
           !weekDays.isEmpty,
           selectedColor != nil,
           selectedEmoji != nil  {
            acceptButton.isEnabled = true
            acceptButton.backgroundColor = .black
        } else {
            acceptButton.isEnabled = false
            acceptButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        }
    }
    
    @objc func cancelButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupScreen(){
        if regularIvent {
            title = "Новая привычка"
            namesOfCell = ["Категория","Расcписание"]
        } else{
            title = "Новое нерегулярное событие"
            namesOfCell = ["Категория"]
            let date = Date()
            let weekday = Calendar.current.component(.weekday, from: date)
            weekDays += [WeekDay(rawValue: weekday) ?? .monday]
        }
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(textView)
        mainStackView.addArrangedSubview(errorLabel)
        textView.addSubview(nameOfNewTracker)
        mainStackView.addArrangedSubview(table)
        mainStackView.addArrangedSubview(colorAndEmojiCollectionView)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(acceptButton)
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        setupConstrains()
    }
    
    private func setupConstrains(){
        scrollView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalToSuperview().offset(-40)
            $0.height.greaterThanOrEqualTo(0)
        }
        textView.snp.makeConstraints {
            $0.height.equalTo(75)
        }
        nameOfNewTracker.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        table.snp.makeConstraints {
            if regularIvent {
                $0.height.equalTo(150)
            } else {
                $0.height.equalTo(75)
            }
        }
        colorAndEmojiCollectionView.snp.makeConstraints { make in
            make.height.equalTo(450)
            make.width.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        errorLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.centerX.equalToSuperview()
        }
    }
}

extension NewHabit : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        namesOfCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newHabitCell") as? NewHabitCell
        cell?.config(nameOfCell: namesOfCell[indexPath.row])
        cell?.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            if let nameOfCategory {
                cell?.setupSubTitle(title: nameOfCategory)
            } else {
                cell?.config(nameOfCell: namesOfCell[indexPath.row])
            }
            cell?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            if !regularIvent {
                cell?.layer.maskedCorners = [.layerMinXMaxYCorner,
                                             .layerMaxXMaxYCorner,
                                             .layerMaxXMinYCorner,
                                             .layerMinXMinYCorner]
                cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right:  table.frame.width / 2)
                return cell ?? UITableViewCell()
            }
        }else if indexPath.row == namesOfCell.count - 1 {
            if let sheduleTitle {
                cell?.setupSubTitle(title: sheduleTitle)
            } else {
                cell?.config(nameOfCell: namesOfCell[indexPath.row])
            }
            cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right:  table.frame.width / 2)
            cell?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell?.layer.cornerRadius = 0
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let categoryScreen = CategoryScreen()
            categoryScreen.delegate = self
            navigationController?.pushViewController(categoryScreen, animated: true)
        } else {
            let sheduleScreen = SheduleScreen()
            sheduleScreen.delegate = self
            navigationController?.pushViewController(sheduleScreen, animated: true)
        }
        
    }
}

extension NewHabit : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty , nameOfCategory != nil , !weekDays.isEmpty, selectedColor != nil, selectedEmoji != nil {
            acceptButton.isEnabled = true
            acceptButton.backgroundColor = .black
        } else {
            acceptButton.isEnabled = false
            acceptButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        }
        if newString.length <= maxLength {
            errorLabel.isHidden = true
            return true
        } else{
            errorLabel.isHidden = false
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return true
    }
}

extension NewHabit : NewHabitSheduleDelegate , NewHabitCategoryDelegate {
    
    func category(titleForCategory: String) {
        nameOfCategory = titleForCategory
        table.reloadData()
    }
    
    func shedule(weekDays: [WeekDay], titleForShedule: String) {
        self.weekDays = weekDays
        sheduleTitle = titleForShedule
        table.reloadData()
    }
}

extension NewHabit: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorsAndEmojiCell",
                                                      for: indexPath) as? ColorsAndEmojisCell
        if indexPath.section == 0 {
            let emoji = emojis[indexPath.row]
            cell?.config(emoji, nil)
            cell?.layer.cornerRadius = 16
        } else if indexPath.section == 1 {
            let color = colors[indexPath.row]
            cell?.config(nil, color)
            cell?.layer.cornerRadius = 8
            cell?.layer.borderWidth = 3
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "head",
            for: indexPath
        ) as? ColorsAndEmojisHeader
        view?.setTitle(indexPath.section == 0 ? "Emoji":"Цвет")
        return view ?? UICollectionReusableView()
    }
}
extension NewHabit: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if indexPath.section == 0 {
            cell?.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
            if let selectedEmoji {
                if indexPath == selectedEmoji {
                    cell?.backgroundColor = .clear
                    self.selectedEmoji = nil
                } else {
                    let oldCell = collectionView.cellForItem(at: selectedEmoji)
                    oldCell?.backgroundColor = .clear
                    self.selectedEmoji = indexPath
                    cell?.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
                }
            } else {
                cell?.backgroundColor =  UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
                self.selectedEmoji = indexPath
            }
        } else {
            if let selectedColor {
                if indexPath == selectedColor {
                    cell?.layer.borderColor = UIColor.clear.cgColor
                    self.selectedColor = nil
                } else {
                    let oldCell = collectionView.cellForItem(at: selectedColor)
                    oldCell?.layer.borderColor = UIColor.clear.cgColor
                    self.selectedColor = indexPath
                    cell?.layer.borderColor = colors[indexPath.row].cgColor
                }
            } else {
                cell?.layer.borderColor = colors[indexPath.row].cgColor
                self.selectedColor = indexPath
            }
        }
        
    }
}
