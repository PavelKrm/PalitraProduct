
import UIKit

protocol AddOrderVCDelegate {
    func setupOrder(order: Order)
}

protocol AddOrderDetailClientDelegate {
    func setOrder(client: Client, partner: Partner)
}

protocol AddOrderProductDelegate {
    func updateTableView()
}

final class AddOrderVC: UIViewController {
  
    @IBOutlet private weak var chooseClientButton: UIButton! {
        didSet {
            chooseClientButton.layer.cornerRadius = 5.0
            chooseClientButton.clipsToBounds = true
            chooseClientButton.backgroundColor = .systemGray5
            chooseClientButton.setTitle(order.client?.clientName, for: .normal)
        }
    }
    @IBOutlet private weak var choosePartnerButton: UIButton! {
        didSet {
            choosePartnerButton.layer.cornerRadius = 5.0
            choosePartnerButton.clipsToBounds = true
            choosePartnerButton.backgroundColor = .systemGray5
            choosePartnerButton.setTitle(order.partner?.name, for: .normal)
        }
    }
    
    @IBOutlet private weak var chooseDeliveryDateTextField: UITextField! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, dd MMMM"
            dateFormatter.locale = Locale(identifier: "Ru-ru")
            chooseDeliveryDateTextField.text = dateFormatter.string(from: order.deliveryDate ?? Date())
        }
    }
    @IBOutlet private weak var chooseTypePriceButton: UIButton! {
        didSet {
            chooseClientButton.isEnabled = false
            chooseClientButton.isHidden = false
            chooseTypePriceButton.layer.cornerRadius = 5.0
            chooseTypePriceButton.clipsToBounds = true
            chooseTypePriceButton.backgroundColor = .systemGray5
            chooseTypePriceButton.setTitle(order.orderTypePriceId, for: .normal)
            
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var sumWithoutFeeLabel: UILabel!
    @IBOutlet private weak var sumWithFeeLabel: UILabel!
    
    var delegate: AddOrderVCDelegate?
    var delegeteData: AddOrderDetailClientDelegate?
//    var delegateProduct: AddOrderProductDelegate?
    private var viewModel: OrdersVMDelegate = OrdersVM()
    private var order: Order = Order() {
        didSet {
            clientId = order.client?.clientId ?? ""
            partnerId = order.partner?.selfId ?? ""
            typePriceId = order.orderTypePriceId ?? ""
            typePriceName = order.orderTypePriceName ?? ""
        }
    }
    private var newOrderId: String = ""
    private var deliveryDate: Date = Date.now
    private var clientId: String = ""
    private var partnerId: String = ""
    private var typePriceId: String = ""
    private var typePriceName: String = ""
    
        //FIXME: - изменить после добавления регистрации
    private var manager: String = "Павел Крампульс"
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        chooseDeliveryDateTextField.resignFirstResponder()
    }
    
    @IBAction private func chooseClientButtonDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clientVC = storyboard.instantiateViewController(withIdentifier: "\(ClientVC.self)") as? ClientVC else {return}
        clientVC.delegate = self
        navigationController?.pushViewController(clientVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        chooseDeliveryDateTextField.inputView = datePicker
    
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        dateFormatter.locale = Locale(identifier: "Ru-ru")
        chooseDeliveryDateTextField.text = dateFormatter.string(from: sender.date)
        deliveryDate = sender.date
    }
    
    @IBAction private func selectTypePriceDidTap() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let propertyVC = storyboard.instantiateViewController(withIdentifier: "\(PropertyVC.self)") as? PropertyVC else {return}
        propertyVC.delegate = self
        propertyVC.modalPresentationStyle = .overCurrentContext
        present(propertyVC, animated: false)
    }
    
    @IBAction private func selectProductButtonDidTap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let productVC = storyboard.instantiateViewController(withIdentifier: "\(ViewController.self)") as? ViewController else {return}
        let nc = UINavigationController(rootViewController: productVC)
        productVC.orderDelegate = self
        if delegate != nil {
            productVC.order = self.order
        } else {
            productVC.serachNewOrder(orderId: newOrderId)
        }
        
        self.present(nc, animated:true, completion: nil)
        saveButtonDidTap()
    }
    
    @IBAction private func saveButtonDidTap() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddhhss"
       
        if order.selfId == nil {
            CoreDataService.mainContext.perform {
                let addingOrder = Order(context: CoreDataService.mainContext)
//FIXME: -  добавить коммент
                addingOrder.selfId = String(Date.now.timeIntervalSince1970)
                self.newOrderId = addingOrder.selfId ?? ""
                addingOrder.orderNumber = dateFormatter.string(from: Date.now)
                addingOrder.orderDate = Date.now
                addingOrder.deliveryDate = self.deliveryDate
                addingOrder.manager = self.manager
                addingOrder.orderSent = false
                addingOrder.orderTypePriceId = self.typePriceId
                
                if let orderClient = Client.getById(id: self.clientId) {
                    addingOrder.client = orderClient
                }
                
                if let orderPartner = Partner.getById(id: self.partnerId) {
                    addingOrder.partner = orderPartner
                }
                
                CoreDataService.saveContext()
            }

        } else {
           
            CoreDataService.mainContext.perform {
                if let order = Order.getById(id: self.order.selfId ?? "") {
//                    order.selfId = self.order.selfId
//                    order.orderNumber = self.order.orderNumber
//                    order.orderDate = self.order.orderDate
                    order.deliveryDate = self.deliveryDate
                    order.manager = self.manager
                    order.orderSent = false
                    order.orderTypePriceId = self.typePriceId
//FIXME: -  добавить коммент
                    
                    if let orderClient = Client.getById(id: self.clientId) {
                        order.client = orderClient
                    }
                    
                    if let orderPartner = Partner.getById(id: self.partnerId) {
                        order.partner = orderPartner
                    }
                }
                CoreDataService.saveContext()
            }
        }
        

//        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    func setOrder(order: Order) {
        self.order = order
       
    }
    
    
}
// MARK: - extension AddOrderVC: UITableViewDelegate
extension AddOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProductOrderCell.self)", for: indexPath) as? ProductOrderCell
        cell?.setup(orderProduct: order.allProduct[indexPath.row])
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83.0
    }
}

// MARK: - extension AddOrderDetailClientDelegate
extension AddOrderVC: AddOrderDetailClientDelegate {
    func setOrder(client: Client, partner: Partner) {
        chooseClientButton.setTitle(client.clientName, for: .normal)
        clientId = client.clientId ?? ""
        choosePartnerButton.setTitle(partner.name, for: .normal)
        partnerId = partner.selfId ?? ""
    }
}
// MARK: - extension AddOrderProductDelegate
extension AddOrderVC: AddOrderProductDelegate {
   
    func updateTableView() {
        tableView.reloadData()
    }
}
extension AddOrderVC: PropertyVCDelegate {
    func updateDate(typeId: String, typeName: String) {
        typePriceId = typeId
        typePriceName = typeName
        self.chooseTypePriceButton.setTitle(typeName, for: .normal)
    }
}


