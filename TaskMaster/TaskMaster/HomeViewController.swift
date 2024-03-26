//
//  HomeViewController.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/2/24.
//

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
    var tasks: [String] = ["Task 1", "Task 2", "Task 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(addButton)
        main_TableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        setupAddButtonConstraints()
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
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
//        let task: Task
//        switch indexPath.section {
//        case 0: task = todayTasks[indexPath.row]
//        case 1: task = thisWeekTasks[indexPath.row]
//        case 2: task = laterTasks[indexPath.row]
//        default: fatalError("Unexpected section")
//        }
//        cell.titleLabel.text = task.title
//        cell.descriptionLabel.text = task.description
        cell.titleLabel.text = "Title information"
        cell.descriptionLabel.text = "descriptive information"
        cell.deadlineLabel.text = "Deadline: 2024-02-23"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        cell.deadlineLabel.text = "Deadline: \(dateFormatter.string(from: task.deadline))"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskDetailVC = TaskDetailViewController()
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
