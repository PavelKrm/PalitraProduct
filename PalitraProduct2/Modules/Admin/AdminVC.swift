

import Foundation
import UIKit

final class AdminVC: UIViewController {
    
    private var viewModel: AdminVMProtocol = AdminVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func readXml() {
        viewModel.firstLoadData()
    }
}
