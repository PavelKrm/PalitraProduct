
import UIKit


class OrdersVC: UIViewController {
    
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
    
    private func showSendAlert(_ order: Order) {
        let alert = UIAlertController(title: "Отправить заказ?", message: "После отправки заказ нельзя редактировать!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .default) { _ in
            self.viewModel.sendOrder(order)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction) -> Void in })
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showDontSendAlert() {
        let alert = UIAlertController(title: "Заказ уже отправлен", message: nil, preferredStyle: .alert)
        
        let okBatton = UIAlertAction(title: "Ок", style: .cancel, handler: { (action : UIAlertAction) -> Void in })
        alert.addAction(okBatton)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.showDeleteAlert(index: indexPath)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
        
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let send = UIContextualAction(style: .normal, title: "Отправить") { _, _, _ in
            if self.viewModel.orders[indexPath.row].orderSent {
                self.showDontSendAlert()
            } else {
                self.showSendAlert(self.viewModel.orders[indexPath.row])
            }
        }
        send.backgroundColor = .systemBlue
        let swipeConfig = UISwipeActionsConfiguration(actions: [send])
        
        return swipeConfig
    }
}
