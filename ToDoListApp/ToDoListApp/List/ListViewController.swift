//
//  ListViewController.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

// MARK: - protocol ListViewProtocol

protocol ListViewProtocol: AnyObject {
    func showList(list: [Todo])
}

// MARK: - class ListViewController

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ListPresenterProtocol?
    
    private let indent: CGFloat = 20
    var list: [Todo]?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title".localized
        label.font = .headline1
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filtersView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var allButton: FilterButton = {
        let button = FilterButton(title: "All", count: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(allButtonPressed), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var openButton: FilterButton = {
       let button = FilterButton(title: "Open", count: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openButtonPressed), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    private lazy var closedButton: FilterButton = {
       let button = FilterButton(title: "Closed", count: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closedButtonPressed), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    private lazy var filterButtonsSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customGray
        return view
    }()
    
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addNewTaskButtonPressed), for: .touchUpInside)
        button.setTitle("addNewTask".localized, for: .normal)
        button.titleLabel?.font = .headline3
        button.setTitleColor(.customBlue, for: .normal)
        button.backgroundColor = .customLightBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = dateFormatter.string(from: Date())
        label.font = .headline2
        label.textColor = .customGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ListItemCell.self,
                                forCellWithReuseIdentifier: ListItemCell.identifier)
        collectionView.backgroundColor = .customLightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        view.backgroundColor = .customLightGray
        self.addSubviews()
        self.setupLayout()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(addNewTaskButton)
        view.addSubview(dateLabel)
        view.addSubview(collectionView)
        view.addSubview(filtersView)
        filtersView.addSubview(allButton)
        filtersView.addSubview(filterButtonsSeparatorView)
        filtersView.addSubview(openButton)
        filtersView.addSubview(closedButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            addNewTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: indent),
            addNewTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 45),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: addNewTaskButton.leadingAnchor, constant: -indent),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: addNewTaskButton.leadingAnchor, constant: -indent),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            
            filtersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filtersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filtersView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: indent),
            filtersView.heightAnchor.constraint(equalToConstant: 30),
            
            allButton.leadingAnchor.constraint(equalTo: filtersView.leadingAnchor, constant: indent),
            allButton.topAnchor.constraint(equalTo: filtersView.topAnchor),
            allButton.bottomAnchor.constraint(equalTo: filtersView.bottomAnchor),
            
            filterButtonsSeparatorView.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 15),
            filterButtonsSeparatorView.topAnchor.constraint(equalTo: filtersView.topAnchor),
            filterButtonsSeparatorView.bottomAnchor.constraint(equalTo: filtersView.bottomAnchor),
            filterButtonsSeparatorView.widthAnchor.constraint(equalToConstant: 2),
            
            openButton.leadingAnchor.constraint(equalTo: filterButtonsSeparatorView.trailingAnchor, constant: 15),
            openButton.centerYAnchor.constraint(equalTo: allButton.centerYAnchor),
            
            closedButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 15),
            closedButton.centerYAnchor.constraint(equalTo: allButton.centerYAnchor),
            closedButton.trailingAnchor.constraint(lessThanOrEqualTo: filtersView.trailingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: allButton.bottomAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func addNewTaskButtonPressed() {
        
    }
    
    @objc private func allButtonPressed() {
        allButton.isSelected = !allButton.isSelected
        openButton.isSelected = !allButton.isSelected
        closedButton.isSelected = !allButton.isSelected
    }
    
    @objc private func openButtonPressed() {
        openButton.isSelected = !openButton.isSelected
        allButton.isSelected = !openButton.isSelected
        closedButton.isSelected = !openButton.isSelected
    }
    
    @objc private func closedButtonPressed() {
        closedButton.isSelected = !closedButton.isSelected
        allButton.isSelected = !closedButton.isSelected
        openButton.isSelected = !closedButton.isSelected
    }
}

// MARK: - extension UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListItemCell.identifier,
            for: indexPath) as? ListItemCell else { return UICollectionViewCell() }
        if let list = list {
            let item = list[indexPath.row]
            collectionCell.configure(
                name: item.todo,
                description: "",
                isCompleted: item.completed) {
                    
                }
        }
            return collectionCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = list {
            list.count
        } else { 0 }
    }
}

// MARK: - extension UICollectionViewDelegateFlowLayout

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = bounds.width - indent * 2
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - extension ListViewProtocol

extension ListViewController: ListViewProtocol {
    func showList(list: [Todo]) {
        self.list = list
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
