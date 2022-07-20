//
//  GroupCell.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 19.07.22.
//

import UIKit

class GroupCell: UITableViewCell {
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var group: [Section] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "\(GroupCell.self)")
        contentView.addSubview(label)
        contentView.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 20, y: 8, width: contentView.frame.size.width - 40.0, height: contentView.frame.size.height)
        tableView.frame = CGRect(x: 20.0, y: contentView.frame.size.height, width: contentView.frame.size.width - 40.0, height: 200)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    func setupCell(with model: Group) {
        label.text = model.name ?? ""
        let group = Group.getArrayById(id: model.groupId ?? "") ?? []
        group.forEach({
            self.group.append(
                Section(
                    title: $0.name ?? "",
                    id: $0.groupId ?? "",
                    options: Group.getArrayById(id: $0.groupId ?? "") ?? []))
        })
    }
}

extension GroupCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return group.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = group[section]
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = group[indexPath.section].title
        } else {
            cell.textLabel?.text = group[indexPath.section].options[indexPath.row - 1].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            group[indexPath.section].isOpened = !group[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            
        }
        
    }
}
