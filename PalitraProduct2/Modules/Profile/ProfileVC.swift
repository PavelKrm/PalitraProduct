import UIKit

final class ProfileVC: UIViewController {
    
    @IBOutlet private weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 100.0
            profileImage.layer.borderWidth = 1.0
            profileImage.layer.borderColor = UIColor.systemBlue.cgColor
            profileImage.clipsToBounds = true
        }
    }
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
        }
    }

    private var viewModel: ProfileVMProtocol = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.update = tableview.reloadData
        viewModel.getUserDefault { profile in
            self.profileImage.image = profile.avatar
            self.fullNameLabel.text = profile.fullname
        }
        print("ViewDidLoad")
    }
    
    
    @IBAction private func signOut() {
        viewModel.signOut()
        showModalAuth()
    }
    
    private func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authVC = storyboard.instantiateViewController(withIdentifier: "\(AuthVC.self)") as? AuthVC else { return }
        authVC.modalPresentationStyle = .overFullScreen
        present(authVC, animated: true)
    }
    
    @IBAction private func editBurBattonDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let setProfileVC = storyboard.instantiateViewController(withIdentifier: "\(SetProfileVC.self)") as? SetProfileVC else { return }
        setProfileVC.delegate = self
        present(setProfileVC, animated: true)
    }
    
    private func showAdminVC() {
        let stroryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let adminVC = stroryboard.instantiateViewController(withIdentifier: "\(AdminVC.self)") as? AdminVC else { return }
        navigationController?.pushViewController(adminVC, animated: true)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.admin {
            return viewModel.optionsAdmin.count
        } else {
            return viewModel.options.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileCell.self)") as? ProfileCell
        if viewModel.admin {
            cell?.setTitle(title: viewModel.optionsAdmin[indexPath.row].title, image: viewModel.optionsAdmin[indexPath.row].image)
        } else {
            cell?.setTitle(title: viewModel.options[indexPath.row].title, image: viewModel.options[indexPath.row].image)
        }
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch  viewModel.tappedTableViewCell(indexPath: indexPath) {
        case .myClientAdmin:
            print("мои клиенты")
        case .myOrdersAdmin:
            print("Мои заказы")
        case .adminVC:
            showAdminVC()
        case .myClient:
            print("мои клиенты")
        case .myOrders:
            print("Мои заказы")
        case .none:
            print("все сломалось")
        }
       
    }

}

extension ProfileVC: SetProfileVCProtocol {
    func updateProfile(image: UIImage, fullName: String) {
        profileImage.image = image
        fullNameLabel.text = fullName
    }
    
    
}
