
import Foundation
import UIKit

final class SetProfileVC: UIViewController {
    
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5.0
            saveButton.layer.borderColor = UIColor.systemGray2.cgColor
            saveButton.layer.borderWidth = 1.0
            saveButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var profileImage: UIImageView!
    
    private var viewModel: SetProfileVMProtocol = SetProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 100.0
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        profileImage.isUserInteractionEnabled = true
    }
    
    @IBAction private func showPicker() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
//    func setImage(image: UIImage) {
//        self.profileImage.image = image
//        
//    }
    
    @IBAction private func saveButtonDidTap() {
        if let image = profileImage.image {
            viewModel.uploadImage(image: image)
        }
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
