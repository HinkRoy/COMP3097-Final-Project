//
//  TaskDetailViewController.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/2/24.
//

import CoreData
import UIKit

class TaskDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    let scrollView = UIScrollView()
    let contentView = UIView()

    let titleLabel = UILabel()
    let titleTextField = UITextField()

    let descriptionLabel = UILabel()
    let descriptionTextView = UITextView()

    var deadlineStackView = UIStackView()
    let deadlineLabel = UILabel()
    let deadlinePicker = UIDatePicker()

    let tagsLabel = UILabel()
    var tagsCollectionView: UICollectionView!
    let tags = ["Health and Fitness", "Personal development", "Work items", "Travel plans", "Socialising Events", "Family tasks"]
    var selectedTags = Set<String>()

    let saveButton = UIButton(type: .system)
    var task: TaskInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Task Detail"
        setupViews()
        if let task = task {
            titleTextField.text = task.title
            if let description = task.taskDescription, !description.isEmpty {
                descriptionTextView.text = description
            } else {
                descriptionTextView.text = "Enter Task Description"
                descriptionTextView.textColor = UIColor.lightGray
            }
            deadlinePicker.date = task.deadline ?? Date()
            if let categories = task.categories as? String {
                selectedTags = Set(categories.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) })
            }
            tagsCollectionView.reloadData()
        } else {
            descriptionTextView.text = "Enter Task Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }

    func setupViews() {
        setupScrollView()
        setupLabelsAndFields()
        setupCollectionView()
        setupSaveButton()

        tagsCollectionView.reloadData()
    }
}

extension TaskDetailViewController {
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

extension TaskDetailViewController {
    func setupLabelsAndFields() {
        titleLabel.text = "Title"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        titleTextField.placeholder = "Enter Task Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)

        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        descriptionTextView.text = "Enter Task Description"
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.delegate = self
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTextView)

        deadlineStackView = UIStackView()
        deadlineStackView.axis = .horizontal
        deadlineStackView.alignment = .center
        deadlineStackView.distribution = .fill
        deadlineStackView.spacing = 8
        deadlineStackView.translatesAutoresizingMaskIntoConstraints = false

        deadlineLabel.text = "Deadline"
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false

        deadlinePicker.datePickerMode = .date
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false

        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(deadlinePicker)

        contentView.addSubview(deadlineStackView)

        tagsLabel.text = "Tags"
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            deadlineStackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            deadlineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deadlineStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            tagsLabel.topAnchor.constraint(equalTo: deadlineStackView.bottomAnchor, constant: 20),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}

extension TaskDetailViewController {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 100, height: 30)
        tagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagsCollectionView.backgroundColor = .none
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        contentView.addSubview(tagsCollectionView)
        tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20),
            tagsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

extension TaskDetailViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tag = tags[indexPath.item]
        let isSelected = selectedTags.contains(tag)
        cell.configure(with: tag, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.item]
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14)
        let textWidth = tag.size(withAttributes: [NSAttributedString.Key.font: font]).width + 30
        return CGSize(width: textWidth, height: 30)
    }
}

extension TaskDetailViewController {
    func setupSaveButton() {
        contentView.addSubview(saveButton)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 22
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc func saveButtonTapped() {
        let title = titleTextField.text ?? ""
        var description = descriptionTextView.text ?? ""
        let deadline = deadlinePicker.date
        let categories = selectedTags.joined(separator: ", ")
        if description == "Enter Task Description" {
            description = ""
        }

        if let task = task {
            updateTaskInfo(task: task, title: title, description: description, deadline: deadline, categories: categories)
        } else {
            saveTaskInfo(title: title, description: description, deadline: deadline, categories: categories)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension TaskDetailViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Task Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Task Description"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension TaskDetailViewController {
    func saveTaskInfo(title: String, description: String, deadline: Date, categories: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TaskInfo", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)

        task.setValue(title, forKey: "title")
        task.setValue(description, forKeyPath: "taskDescription")
        task.setValue(deadline, forKey: "deadline")
        task.setValue(categories, forKey: "categories")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchTaskInfo() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskInfo")

        do {
            let tasks = try managedContext.fetch(fetchRequest)
            return tasks
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    func updateTaskInfo(task: NSManagedObject, title: String?, description: String?, deadline: Date?, categories: String?) {
        if let title = title {
            task.setValue(title, forKey: "title")
        }
        if let description = description {
            task.setValue(description, forKey: "taskDescription")
        }
        if let deadline = deadline {
            task.setValue(deadline, forKey: "deadline")
        }
        if let categories = categories {
            task.setValue(categories, forKey: "categories")
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            try managedContext.save()
            print("Update successful")
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
}
