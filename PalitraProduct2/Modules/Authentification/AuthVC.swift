
import Foundation
import UIKit

final class AuthVC: UIViewController {
    
    @IBOutlet private weak var loginTextField: AuthPickerView!
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTextField.pickerData = ["Павел", "Ольга", "Наталья", "Полина", "Виктор"]
        self.loginTextField.displayNameHandler = { item in
            return (item as? String) ?? ""
        }
        self.loginTextField.itemSelectionHandler = { index, item in
            print("Выбран \(index), \(item as? String ?? "")")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        loginTextField.resignFirstResponder()
    }
}
