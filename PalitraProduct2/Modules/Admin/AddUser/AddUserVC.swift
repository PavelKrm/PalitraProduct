
import Foundation
import UIKit

final class AddUserVC: UIViewController {
    
    @IBOutlet private weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = 100.0
            avatar.layer.borderWidth = 1.0
            avatar.layer.borderColor = UIColor.systemBlue.cgColor
            avatar.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var identifierTextField: UITextField!
    @IBOutlet private weak var firstnameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var accessSwitch: UISwitch!
    @IBOutlet private weak var adminSwitch: UISwitch!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5.0
        }
    }
    
    private var viewModel: AddUserVMProtocol = AddUserVM()
    var delegate: AdminVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
//        chooseDeliveryDateTextField.resignFirstResponder()
    }
    
    @IBAction private func showPicker() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    func showUser(user: FBUser) {
        viewModel.getUserProfile(userID: user.id) { profile in
            self.avatar.image = profile.avatar
            self.identifierTextField.text = user.id
            self.firstnameTextField.text = profile.firstname
            self.lastnameTextField.text = profile.lastname
            self.phoneTextField.text = profile.phone
            self.emailTextField.text = profile.email
            self.accessSwitch.isOn = profile.acsessApp
            self.adminSwitch.isOn = profile.admin
        }
    }
    
    
    @IBAction private func saveButtonDidTap() {
        if delegate != nil {
            if accessSwitch.isOn {
                showSignUpAlert()
            } else {
                viewModel.updateUser(id: identifierTextField.text ?? "", firstName: firstnameTextField.text ?? "",
                                          lastname: lastnameTextField.text ?? "",
                                          avatar: avatar.image ?? UIImage(),
                                          email: emailTextField.text ?? "",
                                          phone: phoneTextField.text ?? "",
                                          admin: adminSwitch.isOn,
                                          acsessApp: accessSwitch.isOn) { result in
                    switch result {
                    case .success(_):
                        self.showErrorAlert(with: "Успешно", and: "Пользователь изменен")
                    case .failure(let error):
                        self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                    }
                }
            }
            
        } else if accessSwitch.isOn {
                showSignUpAlert()
            } else {
                viewModel.updateUser(id: identifierTextField.text ?? "", firstName: firstnameTextField.text ?? "",
                                          lastname: lastnameTextField.text ?? "",
                                          avatar: avatar.image ?? UIImage(),
                                          email: emailTextField.text ?? "",
                                          phone: phoneTextField.text ?? "",
                                          admin: adminSwitch.isOn,
                                          acsessApp: accessSwitch.isOn) { result in
                    switch result {
                    case .success(_):
                        self.showErrorAlert(with: "Успешно", and: "Пользователь изменен")
                    case .failure(let error):
                        self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                    }
                }
            }
    }
    
    private func showSignUpAlert() {
        let alert = UIAlertController(title: "Вы разрешили пользователю доступ к приложению", message: "Зарегистрировать пользователя?", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "Да", style: .default) { _ in
            self.showSignAlert {
                self.delegate?.updateDate()
                self.dismiss(animated: true)
            }
        }
        let cancelButton = UIAlertAction(title: "Нет", style: .destructive) { _ in
            self.viewModel.updateUser(id: self.identifierTextField.text ?? "",
                                      firstName: self.firstnameTextField.text ?? "",
                                      lastname: self.lastnameTextField.text ?? "",
                                      avatar: self.avatar.image ?? UIImage(),
                                      email: self.emailTextField.text ?? "",
                                      phone: self.phoneTextField.text ?? "",
                                      admin: self.adminSwitch.isOn,
                                      acsessApp: self.accessSwitch.isOn) { result in
                switch result {
                case .success(_):
                    self.delegate?.updateDate()
                    self.dismiss(animated: true)
                case .failure(let error):
                    self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSignAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Установите пароль", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Пароль"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .destructive) { [weak alert] _ in
            guard let textField = alert?.textFields else { return }
            if let pass = textField[0].text {
                if pass.count < 6 {
                    self.showAlertCharacterCountWrong()
                } else {
                    self.viewModel.signUpUser(email: self.emailTextField.text ?? "", pass: pass) { result in
                        switch result {
                        case .success(let user):
                            self.viewModel.updateUser(id: user.uid,
                                                      firstName: self.firstnameTextField.text ?? "",
                                                      lastname: self.lastnameTextField.text ?? "",
                                                      avatar: self.avatar.image ?? UIImage(),
                                                      email: self.emailTextField.text ?? "",
                                                      phone: self.phoneTextField.text ?? "",
                                                      admin: self.adminSwitch.isOn,
                                                      acsessApp: self.accessSwitch.isOn) { result in
                                switch result {
                                case .success(_):
                                    completion()
                                case .failure(let error):
                                    self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                }
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertCharacterCountWrong() {
        let alert = UIAlertController(title: "Нужно больше!", message: "Вы ввели слишком мало символов! Минимум - 6.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Хорошо", style:  .default) { _ in
            self.showSignAlert {
                self.delegate?.updateDate()
                self.dismiss(animated: true)
            }
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatar.image = image
        }
        picker.dismiss(animated: true)
    }
}
