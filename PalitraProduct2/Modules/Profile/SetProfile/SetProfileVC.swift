

import Foundation
import UIKit

final class SetProfileVC: UIViewController {
    
    @IBOutlet private weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 100.0
            profileImage.layer.borderWidth = 1.0
            profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func showPicker() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    func setImage(image: UIImage) {
        profileImage.image = image
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
