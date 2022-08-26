import UIKit

final class GroupVC: UIViewController {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var viewModel: GroupVMProtocol = GroupVM()

    var delegate: SelectedGroupDelegate?
    var firstGroupId: String = "a2f53673-6bce-11ec-b76a-b3fbe64f3794"
    var backBarButtonTitle: String = ""
    private var sectionsGroup: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationTitle.backButtonTitle = backBarButtonTitle
        viewModel.update = tableView.reloadData
        viewModel.loadGroup(id: firstGroupId)
        
        viewModel.groups.forEach({
            sectionsGroup.append(Section(title: $0.name ?? "", id: $0.groupId ?? "", options: Group.getArrayById(id: $0.groupId ?? "") ?? []))
        })
    }
    
    private func showChildGroup(groupID: String, title: String) {
        
        let arrayGroup: [Group] = Group.getArrayById(id: groupID) ?? []
        if arrayGroup.isEmpty {
            print("Group is empty")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let nextChild = storyboard.instantiateViewController(withIdentifier: "\(GroupVC.self)") as? GroupVC else {
                print("Error")
                return
            }
            nextChild.delegate = delegate
            nextChild.firstGroupId = groupID
            navigationTitle.backButtonTitle = title
            navigationController?.pushViewController(nextChild, animated: true)
        }
    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GroupCell.self)", for: indexPath) as? GroupCell
        
        if indexPath.row == 0 {
            cell?.setTitle(with: sectionsGroup[indexPath.section].title)
            cell?.backgroundColor = UIColor.systemGray5
        } else {
            cell?.setTitle(with: sectionsGroup[indexPath.section].options[indexPath.row - 1].name ?? "")
        }
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            sectionsGroup[indexPath.section].isOpened = !sectionsGroup[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
            delegate?.showSelectGroup(groupID: sectionsGroup[indexPath.section].id)
        } else {
            
            showChildGroup(groupID: sectionsGroup[indexPath.section].options[indexPath.row - 1].groupId ?? "", title: sectionsGroup[indexPath.section].options[indexPath.row - 1].name ?? "")
            delegate?.showSelectGroup(groupID: sectionsGroup[indexPath.section].options[indexPath.row - 1].groupId ?? "")
        }
    }
    
}


