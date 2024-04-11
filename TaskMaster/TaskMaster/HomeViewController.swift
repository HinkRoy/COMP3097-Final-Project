//
//  HomeViewController.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/2/24.
//

import CoreData
import UIKit
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        return button
    }()

    @IBOutlet var main_TableView: UITableView!
    var tasks: [TaskInfo] = []
    var todayTasks: [TaskInfo] = []
    var thisWeekTasks: [TaskInfo] = []
    var laterTasks: [TaskInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(addButton)
        main_TableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        setupAddButtonConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
    }

    func setupAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    @objc func addTask() {
        let taskDetailVC = TaskDetailViewController()
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }

    func fetchTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TaskInfo>(entityName: "TaskInfo")

        do {
            tasks = try managedContext.fetch(fetchRequest)
            categorizeTasks()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        main_TableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return todayTasks.count
        case 1: return thisWeekTasks.count
        case 2: return laterTasks.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "#ccddfd")!

        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.size.width, height: 40))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textColor = .black

        switch section {
        case 0:
            headerLabel.text = "Today"
        case 1:
            headerLabel.text = "This Week"
        case 2:
            headerLabel.text = "Later"
        default:
            headerLabel.text = ""
        }
        headerView.addSubview(headerLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Today"
        case 1: return "This Week"
        case 2: return "Later"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task: TaskInfo
        switch indexPath.section {
        case 0: task = todayTasks[indexPath.row]
        case 1: task = thisWeekTasks[indexPath.row]
        case 2: task = laterTasks[indexPath.row]
        default: fatalError("Unexpected section")
        }

        cell.titleLabel.text = task.title ?? "No Title"
        cell.descriptionLabel.text = task.taskDescription ?? "No Description"
        if let categoriesString = task.categories as? String {
            let categoriesArray = categoriesString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            cell.categoriesLabel.text = categoriesArray.joined(separator: ", ")
        } else {
            cell.categoriesLabel.text = "No Categories"
        }
        if let deadline = task.deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            cell.deadlineLabel.text = "Deadline: \(dateFormatter.string(from: deadline))"
        } else {
            cell.deadlineLabel.text = "No Deadline"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task: TaskInfo
        switch indexPath.section {
        case 0: task = todayTasks[indexPath.row]
        case 1: task = thisWeekTasks[indexPath.row]
        case 2: task = laterTasks[indexPath.row]
        default: fatalError("Unexpected section")
        }
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.task = task
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = taskForIndexPath(indexPath)
            deleteTask(taskToDelete, at: indexPath)
        }
    }

    func taskForIndexPath(_ indexPath: IndexPath) -> TaskInfo {
        switch indexPath.section {
        case 0: return todayTasks[indexPath.row]
        case 1: return thisWeekTasks[indexPath.row]
        case 2: return laterTasks[indexPath.row]
        default: fatalError("Unexpected section")
        }
    }

    func deleteTask(_ task: TaskInfo, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(task)
        switch indexPath.section {
        case 0:
            todayTasks.remove(at: indexPath.row)
        case 1:
            thisWeekTasks.remove(at: indexPath.row)
        case 2:
            laterTasks.remove(at: indexPath.row)
        default:
            fatalError("Unexpected section")
        }

        do {
            try managedContext.save()
            main_TableView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Could not save after delete: \(error), \(error.userInfo)")
            main_TableView.reloadData()
        }
    }
}

extension HomeViewController {
    func categorizeTasks() {
        let now = Date()
        let calendar = Calendar.current

        todayTasks.removeAll()
        thisWeekTasks.removeAll()
        laterTasks.removeAll()

        for task in tasks {
            guard let deadline = task.deadline else {
                laterTasks.append(task)
                continue
            }

            if calendar.isDateInToday(deadline) {
                todayTasks.append(task)
            } else if calendar.isDate(deadline, equalTo: now, toGranularity: .weekOfYear) {
                thisWeekTasks.append(task)
            } else {
                laterTasks.append(task)
            }
        }
    }
}
