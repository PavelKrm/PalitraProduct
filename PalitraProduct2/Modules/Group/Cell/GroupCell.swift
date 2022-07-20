import UIKit

class GroupCell: UITableViewCell {
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero)

        table.register(GroupCell.self, forCellReuseIdentifier: "\(GroupCell.self)")
        
        return table
    }()
    
    private var selectCell: NSInteger = -1
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
    
    func setupSectionCell(with section: Section) {
        label.text = section.title
        label.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(with model: Group) {
        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GroupCell.self)", for: indexPath) as? GroupCell
        
        if indexPath.row == 0 {
            cell?.setupSectionCell(with: group[indexPath.section])
        } else {
            cell?.setupCell(with: group[indexPath.section].options[indexPath.row - 1])
        }
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            group[indexPath.section].isOpened = !group[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            if selectCell == indexPath.row {
                selectCell = -1
            } else {
                selectCell = indexPath.row
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectCell == indexPath.row {
            return 200
        } else {
            return 50
        }
    }
}
