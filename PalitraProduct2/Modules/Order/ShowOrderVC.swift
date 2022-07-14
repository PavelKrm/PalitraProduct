
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
    
    private var order: Order!
    var orderId: String = "" {
        didSet {
        self.order = Order.getById(id: orderId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        dateFormatter.locale = Locale(identifier: "Ru-ru")
        
        chooseClientBatton.setTitle(order.client?.clientName, for: .normal)
        choosePartnerBatton.setTitle(order.partner?.name, for: .normal)
        chooseDeliveryDateTextField.text = dateFormatter.string(from: order.deliveryDate ?? Date())
        chooseTypePriceBatton.setTitle(order.orderTypePriceName, for: .normal)
        
    }
    

       
    
    
}

extension ShowOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order.allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProductOrderCell.self)", for: indexPath) as? ProductOrderCell
        cell?.setupOldOrder(orderProduct: order.allProduct[indexPath.row])
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
