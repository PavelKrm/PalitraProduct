
import UIKit

class TypePriceTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameTypePriceLabel: UILabel!
    
    func setup(product: TypePrice) {
        nameTypePriceLabel.text = product.name
        
    }
}
