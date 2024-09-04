//
//  ListItemCell.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

final class ListItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ListItemCell"
    private let indent: CGFloat = 10
    
    var onToggleDone: (() -> Void)?
   
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .borderBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

   private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .headline2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.numberOfLines = 7
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createdLabel: UILabel = {
         let label = UILabel()
         label.textColor = .customBlack
         label.textAlignment = .left
         label.text = "created".localized
         label.numberOfLines = 1
         label.font = .bodyBold
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private lazy var dateLabel: UILabel = {
         let label = UILabel()
         label.textColor = .customBlack
         label.textAlignment = .left
         label.text = "created".localized
         label.numberOfLines = 1
         label.font = .bodyRegular
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout() 
        contentView.backgroundColor = .customWhite
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.borderGray?.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    func configure(
        name: String,
        description: String,
        date: String,
        doneButtonAction: @escaping () -> Void) {
            nameLabel.text = name
            descriptionLabel.text = description
            dateLabel.text = date
            onToggleDone = doneButtonAction
        }
    
    // MARK: - Private Methods
    
    @objc private func doneButtonTapped() {
        onToggleDone?()
    }
    
    private func addSubviews() {
        contentView.addSubview(doneButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(createdLabel)
        contentView.addSubview(dateLabel)
    }
  
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            nameLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -indent),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            doneButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            
            createdLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: indent),
            createdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            createdLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            createdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent),
          
            dateLabel.centerYAnchor.constraint(equalTo: createdLabel.centerYAnchor)
        ])
    }
}
