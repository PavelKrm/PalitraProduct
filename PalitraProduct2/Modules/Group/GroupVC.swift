import UIKit

final class GroupVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var selectCell: NSInteger = -1
    private var viewModel: GroupVMProtocol = GroupVM()
    private var firstGroupId: String = "1a"
    private var sectionsGroup: [Section] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.update = tableView.reloadData
        viewModel.loadGroup(id: firstGroupId)
        
        viewModel.groups.forEach({
            sectionsGroup.append(Section(title: $0.name ?? "", id: $0.groupId ?? "", options: Group.getArrayById(id: $0.groupId ?? "") ?? []))
        })
        
        tableView.frame = view.bounds
    }
    
//    private func tapToRow(id: String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(Group.self)") as? GroupVC else { return }
//
//    }
}

//MARK: - extension UITableView
extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionsGroup[section]
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cellGroup = tableView.dequeueReusableCell(withIdentifier: "\(GroupCell.self)", for: indexPath) as? GroupCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = sectionsGroup[indexPath.section].title
        } else {
            cellGroup?.setupCell(with: sectionsGroup[indexPath.section].options[indexPath.row - 1])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sectionsGroup[indexPath.section].isOpened = !sectionsGroup[indexPath.section].isOpened
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



