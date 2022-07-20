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
        viewModel.readDataCheck()
    }
   
}
