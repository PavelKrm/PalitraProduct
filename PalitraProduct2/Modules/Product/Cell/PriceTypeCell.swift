
import UIKit

final class PriceTypeCell: UICollectionViewCell {
    @IBOutlet private weak var nameTypePriceLabel:UILabel!
    @IBOutlet private weak var priceLabel:UILabel!
    
    func priceWithFee(price: Double, fee: Int16) -> NSString {
        let priceWithFee: Double = price * Double(fee) / 100.0 + price
        return NSString(format:"%.2f", priceWithFee)
    }
    
    func setup(price: Price, fee: Int16) {
        
        nameTypePriceLabel.text = price.name
        priceLabel.text = "\(priceWithFee(price: price.price, fee: fee))"
            
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1.0
//        backgroundColor = .secondarySystemBackground
    }
}
