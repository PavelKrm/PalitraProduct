//import UIKit
//
//final class ProfileVC: UIViewController {
//    
//    @IBOutlet private weak var profileImage: UIImageView! {
//        didSet {
//            profileImage.layer.cornerRadius = 100.0
//            profileImage.layer.borderWidth = 1.0
//            profileImage.layer.borderColor = UIColor.systemBlue.cgColor
//        }
//    }
//    @IBOutlet private weak var fullNameLabel: UILabel!
//    @IBOutlet private weak var tableview: UITableView! {
//        didSet {
//            tableview.delegate = self
//            tableview.dataSource = self
//        }
//    }
//
//    private var viewModel: ProfileVMProtocol = ProfileVM()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    
//    
//    @IBAction private func signOut() {
//        viewModel.signOut()
//    }
//    
//    @IBAction private func editBurBattonDidTap() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let setProfileVC = storyboard.instantiateViewController(withIdentifier: "\(SetProfileVC.self)") as? SetProfileVC else { return }
//        setProfileVC.setImage(image: profileImage.image ?? UIImage())
//        present(setProfileVC, animated: true)
//    }
//}
//
//extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//    
//}
