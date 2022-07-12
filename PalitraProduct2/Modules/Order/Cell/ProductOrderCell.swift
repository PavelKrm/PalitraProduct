//
//  ProductOrderCell.swift
//  model.json
//
//  Created by Pol Krm on 28.06.22.
//

import UIKit

class ProductOrderCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var vendorcodeLabel: UILabel!
    @IBOutlet private weak var priceWithFeeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var imageProduct: UIImageView!

    func setup(orderProduct: OrderProduct) {
        let product: Product = Product.getById(id: orderProduct.productId ?? "") ?? Product()
        nameLabel.text = product.name
        barcodeLabel.text = product.barcode
        vendorcodeLabel.text = product.vendorcode
        quantityLabel.text = "\(product.quantity) \(unitViewer(product.unit ?? "", productID: product.selfId ?? ""))"
        imageProduct.image = getImage(imagePath: product.image ?? "")
        priceLabel.text = "\(orderProduct.price)"
        priceWithFeeLabel.text = "\(priceWithFee(price: orderProduct.price, fee: product.percentFee))"
        
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
    func priceWithFee(price: Double, fee: Int16) -> NSString {
        let priceWithFee: Double =
        (price * Double(fee)) / 100.0 + price
        return NSString(format:"%.2f", priceWithFee)
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
