import UIKit

final class ProfileVC: UIViewController {
    
    @IBOutlet private weak var chekMessageLabel: UILabel! {
        didSet {
            chekMessageLabel.isHidden = false
        }
    }

    private var viewModel: ProfileVMProtocol = ProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func readXmlDidTap() {
        FirstLoadData.readXml()
    }
    
    @IBAction private func checkFirebase() {
            
            viewModel.checkFirestore { check in
                
                self.chekMessageLabel.text = check.message
                
            }
        }
    @IBAction private func addPrdouctsInFirebase() {
        viewModel.udateDocumentCheckFB()
    }
   
    
}
