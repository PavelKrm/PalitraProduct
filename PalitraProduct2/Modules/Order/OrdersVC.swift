
import UIKit

class OrdersVC: UIViewController, AddOrderVCDelegate {
    
    @IBOutlet private weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
        }
    }
    
    private var viewModel: OrdersVMDelegate = OrdersVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.update = tableview.reloadData
        viewModel.loadDate()
    }
    
    func setupOrder(order: Order) {
        viewModel.order = order
    }
    

    
    @IBAction private func addButtonDidTap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addOrderVC = storyboard.instantiateViewController(withIdentifier: "\(AddOrderVC.self)") as? AddOrderVC else {return}
        let nc = UINavigationController(rootViewController: addOrderVC)
        self.present(nc, animated:true, completion: nil)
    }
    
    private func openOrder(orderId: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let orderVC = storyboard.instantiateViewController(withIdentifier: "\(ShowOrderVC.self)") as? ShowOrderVC else {return}
        orderVC.orderId = orderId
        navigationController?.pushViewController(orderVC, animated: true)

    }
    
    
    
    private func showDeleteAlert(index: IndexPath) {
        let alert = UIAlertController(title: "Удалить заказ?", message: "Заказ будет удален безвозвратно!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .destructive, handler: { _ in
            self.viewModel.removeOrder(order: self.viewModel.orders[index.row])
            self.viewModel.loadDate()

        })
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - extension OrdersVC: UITableViewDelegate-/-DataSource
extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderCell.self)", for: indexPath) as? OrderCell
        cell?.setup(order: viewModel.orders[indexPath.row])
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openOrder(orderId: viewModel.orders[indexPath.row].selfId ?? "")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlert(index: indexPath)
        }
    }
}
