import UIKit

final class GroupVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var viewAnimate: UIView!
    @IBOutlet weak var xCenterConstraint: NSLayoutConstraint!
    {
        didSet {
            xCenterConstraint.constant -= UIScreen.main.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showaAnimation()
    }
    
    private var viewModel: GroupVMProtocol = GroupVM()
    var firstGroupId: String = "a2f53673-6bce-11ec-b76a-b3fbe64f3794"
    private var sectionsGroup: [Section] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.update = tableView.reloadData
        viewModel.loadGroup(id: firstGroupId)
        
        viewModel.groups.forEach({
            sectionsGroup.append(Section(title: $0.name ?? "", id: $0.groupId ?? "", options: Group.getArrayById(id: $0.groupId ?? "") ?? []))
        })
    }
    
    @IBAction func didSwipe() {
        hideAnimation()
    }
    
    private func showChildGroup(groupID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextChild = storyboard.instantiateViewController(withIdentifier: "\(GroupVC.self)") as? GroupVC else {
            
            print("Error")
            return
            
        }
        nextChild.firstGroupId = groupID
        navigationController?.pushViewController(nextChild, animated: true)
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
            cell?.backgroundColor = UIColor.systemGray2
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
        } else {
           print("tap to \(sectionsGroup[indexPath.section].options[indexPath.row - 1].name ?? "")")
            showChildGroup(groupID: sectionsGroup[indexPath.section].options[indexPath.row - 1].groupId ?? "")
        }
    }
    
    //MARK: - Animation
    
    private func showaAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.xCenterConstraint.constant += (UIScreen.main.bounds.width / 2)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.xCenterConstraint.constant -= (UIScreen.main.bounds.width / 2 )
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
}



