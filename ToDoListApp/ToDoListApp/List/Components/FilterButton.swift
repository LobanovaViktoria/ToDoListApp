//
//  FilterButton.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 03.09.2024.
//

import UIKit

final class FilterButton: UIControl {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .customGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .customWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var countLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            countLabelView.backgroundColor = isSelected ? .customBlue : .customGray
            titleLabel.textColor = isSelected ? .customBlue : .customGray
        }
    }
    
    // MARK: - LifeCycle
    
    init(
        title: String,
        count: Int
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        countLabel.text = String(count)
        
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        addSubview(titleLabel)
        countLabelView.addSubview(countLabel)
        addSubview(countLabelView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            countLabelView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            countLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabelView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            countLabelView.heightAnchor.constraint(equalToConstant: 20),
            countLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            countLabel.leadingAnchor.constraint(equalTo: countLabelView.leadingAnchor, constant: 6),
            countLabel.trailingAnchor.constraint(equalTo: countLabelView.trailingAnchor, constant: -6),
            countLabel.topAnchor.constraint(equalTo: countLabelView.topAnchor),
            countLabel.bottomAnchor.constraint(equalTo: countLabelView.bottomAnchor)
        ])
    }
}

