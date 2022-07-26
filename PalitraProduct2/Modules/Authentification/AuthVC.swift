
import Foundation
import UIKit

final class AuthVC: UIViewController {
    
    @IBOutlet private weak var loginTextField: AuthPickerView! {
        didSet {
            loginTextField.layer.cornerRadius = 5.0
            loginTextField.layer.borderWidth = 1.0
            loginTextField.layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    @IBOutlet private weak var passTextField: UITextField! {
        didSet {
            passTextField.layer.cornerRadius = 5.0
            passTextField.layer.borderWidth = 1.0
            passTextField.layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    @IBOutlet private weak var logInButton: UIButton! {
        didSet {
            logInButton.layer.cornerRadius = 5.0
            logInButton.layer.borderWidth = 1.0
            logInButton.layer.borderColor = UIColor.systemGray.cgColor
            logInButton.backgroundColor = .systemBlue
        }
    }
    
    @IBOutlet private weak var forgotPassButton: UIButton!
    private var viewModel: AuthVMProtocol = AuthVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getUsers { result in
            switch result {
            case .success(let users):
                self.loginTextField.pickerData = users
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        self.loginTextField.displayNameHandler = { item in
            return (item as? String) ?? ""
        }
        self.loginTextField.itemSelectionHandler = { index, item in
            self.viewModel.getFBUser(username: item as? String ?? "")
           
            print("Выбран \(index), \(item as? String ?? "")")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        loginTextField.resignFirstResponder()
    }
    
    @IBAction private func signInButtoDidTap() {
        viewModel.signIn(pass: passTextField.text ?? "") {
            self.dismiss(animated: true)
        }
        
    }
    
}
