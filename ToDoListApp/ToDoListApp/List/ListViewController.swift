//
//  ListViewController.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

protocol ListViewProtocol: AnyObject {
    func showList()
}

class ListViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: ListPresenterProtocol?
    
    private let indent: CGFloat = 20
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
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
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .borderBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ListItemCell.self,
                                forCellWithReuseIdentifier: ListItemCell.identifier)
        collectionView.backgroundColor = .backgroundGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
   
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundGray
        addSubviews()
        setupLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        presenter?.viewDidLoaded()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(plusButton)
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func plusButtonTapped() {
        
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
        collectionCell.configure(
            name: "sjdfn dsfs sdf  sjifs",
            description: "ssdfsssdfssdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kkssdfssdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kkssdfssdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kkssdfssdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kkssdfssdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kksdsdds sdkjn kjnk kjnk kjn kjn kjn kjn kk",
            date: dateFormatter.string(from: Date())
        ) {
                print("done")
        } 
        return collectionCell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           10
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
            let width = (bounds.width - 48)/2
            return CGSize(width: width, height: 240)
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
    func showList() {
         
    }
}
