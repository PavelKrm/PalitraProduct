
import UIKit

final class SideNC: UINavigationController {
    
    var sideMenuDelegate: SelectedGroupDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let rootVC = viewControllers.first as? GroupVC {
            rootVC.delegate = sideMenuDelegate
        }
    }
}
