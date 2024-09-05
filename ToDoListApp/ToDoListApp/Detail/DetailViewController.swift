//
//  DetailViewController.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

// MARK: - protocol DetailViewProtocol

protocol DetailViewProtocol: AnyObject {
    
}

// MARK: - class DetailViewController

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var presenter: DetailPresenterProtocol?
    private let indent: CGFloat = 20
    private let userID = 1000
    private var isCompleted = false
    private var event: Event
    private var selectedTodo: TodoModel?
    
    // MARK: - UI
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.setTitle("save".localized, for: .normal)
        button.titleLabel?.font = .headline3
        button.setTitleColor(.customBlue, for: .normal)
        button.backgroundColor = .customLightBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.setTitle("cancel".localized, for: .normal)
        button.titleLabel?.font = .caption1
        button.setTitleColor(.customBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = event.titleVC
        label.font = .headline1
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backgroundScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .customWhite
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.text = "todo".localized
        label.font = .headline3
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var todoTextView: UITextView = {
        let text = UITextView()
        if selectedTodo != nil {
            text.text = selectedTodo?.todo
        }
        text.font = .caption2
        text.textColor = .customBlack
        text.backgroundColor = .customLightGray
        text.layer.cornerRadius = 10
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description".localized
        label.font = .headline3
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let text = UITextView()
        if selectedTodo != nil {
            text.text = selectedTodo?.descriptionTodo
        }
        text.font = .caption2
        text.textColor = .customBlack
        text.backgroundColor = .customLightGray
        text.layer.cornerRadius = 10
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "created".localized
        label.font = .headline3
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if selectedTodo != nil  {
            datePicker.date = selectedTodo?.date ?? Date()
        }
        datePicker.backgroundColor = .customWhite
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .customBlack
        datePicker.datePickerMode = .date
        datePicker.layer.masksToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.text = "completed".localized
        label.font = .headline3
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completedSwitch: UISwitch = {
        let completed = UISwitch()
        if selectedTodo != nil {
            completed.isOn = selectedTodo?.completed ?? false
        }
        completed.onTintColor = .customBlue
        completed.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        completed.translatesAutoresizingMaskIntoConstraints = false
        return completed
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.setTitle("delete".localized, for: .normal)
        button.titleLabel?.font = .headline3
        button.setTitleColor(.customRed, for: .normal)
        button.backgroundColor = .customLightRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init()
    
    init(_ event: Event, todo: TodoModel?) {
        self.event = event
        self.selectedTodo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customLightGray
        addSubviews()
        setupLayout()
        todoTextView.becomeFirstResponder()
        addGesture()
    }
}

// MARK: - private Methods

private extension DetailViewController {
    
    func addSubviews() {
        view.addSubview(saveButton)
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(todoLabel)
        contentView.addSubview(todoTextView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(completedLabel)
        contentView.addSubview(completedSwitch)
        if event == .edit {
            contentView.addSubview(deleteButton)
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: indent),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: indent),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            cancelButton.heightAnchor.constraint(equalToConstant: 45),
            
            titleLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: indent),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            
            backgroundScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: indent),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indent),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indent),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -indent),
            
            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 550),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - indent * 2),
            
            todoLabel.centerYAnchor.constraint(equalTo: todoTextView.centerYAnchor),
            todoLabel.trailingAnchor.constraint(lessThanOrEqualTo: todoTextView.leadingAnchor, constant: -indent),
            todoLabel.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor, constant: indent),
            todoLabel.heightAnchor.constraint(equalToConstant: 20),
            
            todoTextView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor, constant: indent),
            todoTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            todoTextView.heightAnchor.constraint(equalToConstant: 60),
            todoTextView.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: descriptionTextView.centerYAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: -indent),
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor, constant: indent),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: todoTextView.bottomAnchor, constant: indent),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 110),
            
            dateLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: -indent),
            dateLabel.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor, constant: indent),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            datePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: indent),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            datePicker.heightAnchor.constraint(equalToConstant: 30),
            
            completedLabel.centerYAnchor.constraint(equalTo: completedSwitch.centerYAnchor),
            completedLabel.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: -indent),
            completedLabel.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor, constant: indent),
            completedLabel.heightAnchor.constraint(equalToConstant: 20),
            
            completedSwitch.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: indent),
            completedSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            completedSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        if event == .edit {
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: completedSwitch.bottomAnchor, constant: indent * 3),
                deleteButton.centerXAnchor.constraint(equalTo: backgroundScrollView.centerXAnchor),
                deleteButton.heightAnchor.constraint(equalToConstant: 45),
                deleteButton.widthAnchor.constraint(equalToConstant: 180)
            ])
        }
    }
    
    @objc func onSwitchValueChanged(_ control: UISwitch) {
        isCompleted = control.isOn
    }
    
    @objc func saveButtonPressed() {
        if event == .add {
            let todo: TodoModel = TodoModel(
                id: Int.random(in: 100...10000),
                todo: todoTextView.text,
                completed: isCompleted,
                userId: userID,
                date: datePicker.date,
                descriptionTodo: descriptionTextView.text
            )
            presenter?.saveNewTodo(todo: todo)
        } else {
            if let selectedTodo {
                let todo: TodoModel = TodoModel(
                    id: selectedTodo.id,
                    todo: todoTextView.text,
                    completed: completedSwitch.isOn,
                    userId: selectedTodo.userId,
                    date: datePicker.date,
                    descriptionTodo: descriptionTextView.text
                )
                presenter?.updateTodo(selectedTodo, todo)
            }
        }
    }
    
    @objc func cancelButtonPressed() {
        presenter?.closeDetail()
    }
    
    @objc func hideKeyboardAction() {
        contentView.endEditing(true)
    }
    
    @objc func deleteButtonPressed() {
        let alert = UIAlertController(
            title: "deleteMessage".localized,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "delete".localized,
            style: .destructive
        ) { [weak self] _ in
            guard let selectedTodo = self?.selectedTodo else { return }
            self?.presenter?.deleteTodo(todo: selectedTodo)
        })
        alert.addAction(UIAlertAction(
            title: "cancel".localized,
            style: .cancel) { _ in
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        contentView.addGestureRecognizer(tapGesture)
    }
}

extension DetailViewController: DetailViewProtocol {
    
}

