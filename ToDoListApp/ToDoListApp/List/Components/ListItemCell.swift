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
    
    private lazy var dateFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    // MARK: - UI
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

   private lazy var taskName: UILabel = {
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
        label.textColor = .customGray
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var createdLabel: UILabel = {
         let label = UILabel()
         label.textColor = .customGray
         label.textAlignment = .left
         label.text = "created".localized
         label.numberOfLines = 1
         label.font = .headline3
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private lazy var dateLabel: UILabel = {
         let label = UILabel()
         label.textColor = .customGray
         label.textAlignment = .left
         label.numberOfLines = 1
         label.font = .headline3
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    func configure(
        name: String,
        description: String,
        isCompleted: Bool,
        date: Date,
        doneButtonAction: @escaping () -> Void) {
            if isCompleted {
                doneButton.setImage(UIImage(
                    systemName: "checkmark.circle.fill"), for: .normal)
                doneButton.imageView?.tintColor = UIColor.customBlue
                taskName.attributedText = NSAttributedString(string: name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                
            } else {
                doneButton.setImage(UIImage(
                    systemName:  "circle"
                ), for: .normal)
                doneButton.imageView?.tintColor =
                 UIColor.customLightGray
                taskName.attributedText = NSAttributedString(string: name, attributes: [:])
            }
            descriptionLabel.text = description
            onToggleDone = doneButtonAction
            dateLabel.text = dateFormatterShort.string(from: date)
        }
    
    // MARK: - Private Methods
    
    @objc private func doneButtonTapped() {
        onToggleDone?()
    }
    
    private func addSubviews() {
        contentView.addSubview(doneButton)
        contentView.addSubview(taskName)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(createdLabel)
        contentView.addSubview(dateLabel)
    }
  
    private func setupLayout() {
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent),
            taskName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            taskName.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -indent),
            taskName.heightAnchor.constraint(equalToConstant: 60),
        
            descriptionLabel.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            descriptionLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -indent),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            
            dividerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: indent),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            
            createdLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: indent),
            createdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            createdLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -3),
            createdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent),
          
            dateLabel.centerYAnchor.constraint(equalTo: createdLabel.centerYAnchor)
        ])
    }
}
