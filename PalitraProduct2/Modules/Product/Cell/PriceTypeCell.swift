
import UIKit

final class PriceTypeCell: UICollectionViewCell {
    @IBOutlet private weak var nameTypePriceLabel:UILabel!
    @IBOutlet private weak var priceLabel:UILabel!
    
    func priceWithFee(price: Double, fee: Int16) -> NSString {
        let priceWithFee: Double = price * Double(fee) / 100.0 + price
        return NSString(format:"%.2f", priceWithFee)
    }
    
    func setup(price: Price, product: Product) {
        
        nameTypePriceLabel.text = price.name
        priceLabel.text = "\(priceWithFee(price: price.price, fee: product.percentFee))"
            
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .secondarySystemBackground
    }
}
