import UIKit

final class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func readXmlDidTap() {
        FirstLoadData.readXml()
    }
   
}
