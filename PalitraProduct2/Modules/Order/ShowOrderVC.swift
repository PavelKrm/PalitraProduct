
import Foundation
import UIKit

final class ShowOrderVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var chooseClientBatton: UIButton!
    @IBOutlet private weak var choosePartnerBatton: UIButton!
    @IBOutlet private weak var chooseDeliveryDateTextField: UITextField!
    @IBOutlet private weak var chooseTypePriceBatton: UIButton!
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var sumWithoutFeeLabel: UILabel!
    @IBOutlet private weak var sumWithFeeLabel: UILabel!
    
    
    var orderId: String = ""
    private var viewModel: ShowOrderVMProtocol = ShowOrderVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.update = tableView.reloadData
        viewModel.loadOrder(orderId)
        setTextInLabel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        dateFormatter.locale = Locale(identifier: "Ru-ru")
        
        chooseClientBatton.setTitle(viewModel.order.client?.clientName, for: .normal)
        choosePartnerBatton.setTitle(viewModel.order.partner?.name, for: .normal)
        chooseDeliveryDateTextField.text = dateFormatter.string(from: viewModel.order.deliveryDate ?? Date())
        chooseTypePriceBatton.setTitle(viewModel.order.orderTypePriceName, for: .normal)
        
    }
    
    private func setTextInLabel() {
        
            var sumWithoutFee: Double = 0.0
            var sumWithFee: Double = 0.0
        viewModel.order.allProduct.forEach({
                sumWithoutFee += $0.price
                sumWithFee += (($0.price * $0.percentFee) / 100.0) + $0.price
            })
        productCountLabel.text = "Всего товаров: \(viewModel.order.allProduct.count)"
            sumWithoutFeeLabel.text = "Сумма без НДС: \(doubleInString(price: sumWithoutFee))"
        sumWithFeeLabel.text = "Сумма c НДС: \(doubleInString(price: sumWithFee))"
        
    }
    
    func doubleInString(price: Double) -> NSString {
        return NSString(format:"%.2f", price)
    }
}

extension ShowOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.order.allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProductOrderCell.self)", for: indexPath) as? ProductOrderCell
        cell?.setupOldOrder(orderProduct: viewModel.order.allProduct[indexPath.row])
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
