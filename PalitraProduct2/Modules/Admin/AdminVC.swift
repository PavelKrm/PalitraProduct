
import Foundation
import UIKit

protocol AdminVCDelegate {
    func updateDate()
}

final class AdminVC: UIViewController {
    
    @IBOutlet private weak var usersCountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var viewModel: AdminVMProtocol = AdminVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.update = tableView.reloadData
        viewModel.getUsers { result in
            switch result {
            case .success(let users):
                self.usersCountLabel.text = "\(users.count)"
            case .failure(let error):
                self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func addUser() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addUserVC = storyboard.instantiateViewController(withIdentifier: "\(AddUserVC.self)") as? AddUserVC else { return }
        
        present(addUserVC, animated: true)
        
    }
    
    @IBAction private func readXml() {
        viewModel.firstLoadData()
    }
    
    @IBAction private func updateProductsInDB() {
        viewModel.uploadProductsInFB { result in
            switch result {
            case .success(let message):
                self.showErrorAlert(with: "Выгрузка завершена!", and: message)
            case .failure(let error):
                self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    private func showUser(user: FBUser) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addUserVC = storyboard.instantiateViewController(withIdentifier: "\(AddUserVC.self)") as? AddUserVC else { return }
        addUserVC.delegate = self
        addUserVC.showUser(user: user)
        present(addUserVC, animated: true)
    }
    
    private func showErrorAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func removeCoreData() {
        viewModel.removeCoreData()
    }
}

extension AdminVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(AdminVCCell.self)", for: indexPath) as? AdminVCCell
        cell?.showName(fullName: viewModel.users[indexPath.row].fullname)
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showUser(user: viewModel.users[indexPath.row])
        
    }
}

extension AdminVC: AdminVCDelegate {
    
    func updateDate() {
        viewModel.getUsers { result in
            switch result {
            case .success(let users):
                self.usersCountLabel.text = "\(users.count)"
            case .failure(let error):
                self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}
