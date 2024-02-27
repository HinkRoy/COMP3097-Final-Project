//
//  TaskDetailViewController.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/2/24.
//

import UIKit

class TaskDetailViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let saveButton = UIButton(type: .system)
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let deadlinePicker = UIDatePicker()
    let tagsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Task Detail"
        setupSaveButton()
        setupScrollView()
        setupContentView()
        setupTitleTextField()
        setupDescriptionTextView()
        setupDeadlinePicker()
        setupTagsStackView()
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -5)
        ])
    }


    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 22

        NSLayoutConstraint.activate([
//            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        ])
    }

    func setupTitleTextField() {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Please enter the task title information"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func setupDescriptionTextView() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.text = "Please enter task description information"
        
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func setupDeadlinePicker() {
        let deadlineLabel = UILabel()
        deadlineLabel.text = "Deadline"
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [deadlineLabel, deadlinePicker])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }


    func setupTagsStackView() {
        tagsStackView.axis = .vertical
        tagsStackView.distribution = .fillEqually
        tagsStackView.spacing = 15
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tags = ["Health and Fitness", "Personal development", "Work items", "Travel plans", "Socialising Events", "Family tasks"]
        var currentRowStackView = createHorizontalStackView()
        
        tags.forEach { tag in
            let button = UIButton(type: .system)
            button.setTitle(tag, for: .normal)
            button.addTarget(self, action: #selector(tagSelected(_:)), for: .touchUpInside)
            button.backgroundColor = UIColor.lightGray
            button.layer.cornerRadius = 5
            let buttonWidth = button.intrinsicContentSize.width + 20
            if currentRowStackView.frame.width + buttonWidth > contentView.frame.width {
                tagsStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createHorizontalStackView()
            }
            currentRowStackView.addArrangedSubview(button)
        }
        tagsStackView.addArrangedSubview(currentRowStackView)
        contentView.addSubview(tagsStackView)
        
        NSLayoutConstraint.activate([
            tagsStackView.topAnchor.constraint(equalTo: deadlinePicker.bottomAnchor, constant: 20),
            tagsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }

    func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        return stackView
    }

    @objc func tagSelected(_ sender: UIButton) {
        print("Tag selected: \(sender.title(for: .normal) ?? "")")
    }

}
