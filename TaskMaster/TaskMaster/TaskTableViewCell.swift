//
//  TableViewCell.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/2/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let categoriesLabel = UILabel()
    let deadlineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        
        categoriesLabel.font = .systemFont(ofSize: 12)
        categoriesLabel.numberOfLines = 0
        categoriesLabel.textColor = .blue
        
        deadlineLabel.font = .systemFont(ofSize: 14)
        deadlineLabel.textColor = .red
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, categoriesLabel, deadlineLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

//    func configure(with task: Task) {
//        titleLabel.text = task.title
//        descriptionLabel.text = task.description
//        categoriesLabel.text = task.categories.joined(separator: ", ")
//        deadlineLabel.text = "Deadline: \(task.deadlineFormatted)" 
//    }
}

