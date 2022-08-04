
import Foundation
import UIKit

protocol SetProfileVCProtocol {
    
    func updateProfile(image: UIImage, fullName: String)
}

final class SetProfileVC: UIViewController {
    
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5.0
            saveButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var changeDataSignUp: UIButton! {
        didSet {
            changeDataSignUp.layer.cornerRadius = 5.0
            changeDataSignUp.layer.backgroundColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 100.0
            profileImage.layer.borderWidth = 1.0
            profileImage.layer.borderColor = UIColor.systemBlue.cgColor
            profileImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var nameTextField: UITextField!{
        didSet {
            nameTextField.layer.borderColor = UIColor.systemBlue.cgColor
            nameTextField.layer.borderWidth = 1.0
            nameTextField.layer.cornerRadius = 5.0
            nameTextField.layer.shadowRadius = 10.0
            nameTextField.layer.shadowColor = UIColor.systemGray5.cgColor
            nameTextField.layer.shadowOpacity = 0.5
            
        }
    }
    @IBOutlet private weak var lastnameTextField: UITextField! {
        didSet {
            lastnameTextField.layer.borderColor = UIColor.systemBlue.cgColor
            lastnameTextField.layer.borderWidth = 1.0
            lastnameTextField.layer.cornerRadius = 5.0
            lastnameTextField.layer.shadowRadius = 10.0
            lastnameTextField.layer.shadowColor = UIColor.systemGray5.cgColor
            lastnameTextField.layer.shadowOpacity = 0.5
        }
    }
    @IBOutlet private weak var phoneTextField: UITextField! {
        didSet {
            phoneTextField.layer.borderColor = UIColor.systemBlue.cgColor
            phoneTextField.layer.borderWidth = 1.0
            phoneTextField.layer.cornerRadius = 5.0
            phoneTextField.layer.shadowRadius = 10.0
            phoneTextField.layer.shadowColor = UIColor.systemGray5.cgColor
            phoneTextField.layer.shadowOpacity = 0.5
        }
    }
    
    private var viewModel: SetProfileVMProtocol = SetProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getUserDefault { profile in
//            profile in
            self.profileImage.image = profile.avatar
//            self.nameTextField.text = profile.firstname
//            self.lastnameTextField.text = profile.lastname
//            self.phoneTextField.text = profile.phone
        }
        
        viewModel.getCurrentUser { user in
            self.nameTextField.text = user.firstname
            self.lastnameTextField.text = user.lastname
            self.phoneTextField.text = user.phone
        }
    }
    
    var delegate: SetProfileVCProtocol?
    
    @IBAction private func showPicker() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    @IBAction private func saveButtonDidTap() {
        if let image = profileImage.image {
            viewModel.uploadImage(image: image)
            delegate?.updateProfile(image: image, fullName: "\(self.nameTextField.text ?? "") \(self.lastnameTextField.text ?? "")")
        }
        
        
        
        viewModel.saveProfileDefaults(avatar: profileImage.image ?? UIImage(),
                                      firsName: nameTextField.text ?? "",
                                      lastname: lastnameTextField.text ?? "",
                                      phone: phoneTextField.text ?? "") {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction private func changeSignUpData() {
        showAlertChangeSignData()
    }
    
    private func showAlertChangeSignData() {
        let alert = UIAlertController(title: "Изменить данные?", message: "Выберите что меняем:", preferredStyle: .actionSheet)
        let emailButton = UIAlertAction(title: "Email", style: .default) { _ in
            self.showAlertChangeEmail()
        }
        let passButton = UIAlertAction(title: "Пароль", style: .default) { _ in
            self.showAlertChangePassword()
        }
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alert.addAction(emailButton)
        alert.addAction(passButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertChangeEmail() {
        let alert = UIAlertController(title: "Изменить email?", message: "Введите данные", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .destructive) { [weak alert] _ in
            guard let textField = alert?.textFields else { return }
            if let email = textField[0].text {
                self.viewModel.changeEmail(email: email)
                print("Message: - email has been changed")
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertChangePassword() {
        let alert = UIAlertController(title: "Изменить пароль?", message: "Введите данные", preferredStyle: .alert)
        
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
                    self.viewModel.changePassword(pass: pass) { result in
                        switch result {
                        case .success(let success):
                            self.showErrorAlert(with: success, and: "Пароль изменен")
                        case .failure(let error):
                            self.showErrorAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                    print("Message: - password has been changed")
                }
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertCharacterCountWrong() {
        let alert = UIAlertController(title: "Нужно больше!", message: "Вы ввели слишком мало символов! Минимум - 6.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Хорошо", style:  .default) { _ in
            self.showAlertChangePassword()
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

extension SetProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImage.image = image
        }
        picker.dismiss(animated: true)
    }
}
