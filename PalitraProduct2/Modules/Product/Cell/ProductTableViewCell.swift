import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 100.5
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var manufacturerLabel: UILabel!
    @IBOutlet private weak var feeLabale: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var typePriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var imageProduct: UIImageView!
    
    private var product: Product!
    
    var delegate: PropertyVCDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
    
    func setup(product: Product) {
        
        layer.cornerRadius = 15.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.product = product
        
        manufacturerLabel.text = product.manufacturer
        feeLabale.text = "\(product.fee ?? "") \(product.percentFee)%"
        nameLabel.text = product.name
        imageProduct.image = getImage(imagePath: product.image ?? "")
        barcodeLabel.text = product.barcode
        quantityLabel.text = "Остаток: \(product.quantity) \(unitViewer(product.unit ?? "", productID: product.selfId ?? ""))"
        product.allPrices.forEach({
            if $0.selfId == ProductVM.typePriceID {
                typePriceLabel.text = $0.name
                if $0.price == 0.00 {
                    typePriceLabel.text = ProductVM.defaultPriceName
                    typePriceLabel.textColor = .red
                    let price: Double = searchDefaultPrice(product)
                    priceLabel.text = "\(priceWithFee(price: price, fee: product.percentFee)) руб. за \(unitViewer(product.unit ?? "", productID: product.selfId ?? ""))"
                } else {
                    typePriceLabel.textColor = .gray
                    priceLabel.text = "\(priceWithFee(price: $0.price, fee: product.percentFee)) руб. за \(unitViewer(product.unit ?? "", productID: product.selfId ?? ""))"
                }
            }
        })
        
    }
   
    func searchDefaultPrice(_ product: Product) -> Double {
        var price: Double = 0.00
        product.allPrices.forEach({
            if $0.selfId == ProductVM.defaultPriceID {
                        price = $0.price
                    }
                })
        return price
    }
        
    func priceWithFee(price: Double, fee: Int16) -> NSString {
        let priceWithFee: Double = price * Double(fee) / 100.0 + price
        return NSString(format:"%.2f", priceWithFee)
    }
    func unitViewer(_ unit: String, productID: String) -> String {
        if unit == "704 " {
            return "наб."
        } else {
            if unit == "796 " {
                return "шт."
            } else {
                if unit == "778 " {
                    return "уп."
                } else {
                    if unit == "625 " {
                        return "лист"
                    } else {
                print("ERROR: unit contains diffrent value in product.id - \(productID) ")
                return "error"
                    }
                }
            }
        }
    }
    
    private func getImage(imagePath: String) -> UIImage {
        let path = imagePath.split(separator: ".").first
        let type = imagePath.split(separator: ".").last
        let imagePath = Bundle.main.path(forResource: "\(path ?? "")", ofType: "\(type ?? "")")
        let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath ?? ""))
        let image = UIImage(data: data ?? Data())
        return image ?? UIImage(systemName: "nosign")!
    }
    
}
// MARK: - extension UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.allPrices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PriceTypeCell.self)", for: indexPath) as? PriceTypeCell
        cell?.setup(price: product.allPrices[indexPath.row], product: product)
        return cell ?? .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 46)
    }
}
