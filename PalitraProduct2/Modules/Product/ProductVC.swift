import UIKit
import AEXML
import FirebaseAuth

protocol SelectedGroupDelegate {
    func showSelectGroup(groupID: String)
}

final class ProductVC: UIViewController, PropertyVCDelegate {
    
    @IBOutlet private weak var sideView: UIView!
    @IBOutlet private weak var xCenterConstraintSideView: NSLayoutConstraint!
    @IBOutlet private weak var productView: UIView!
    @IBOutlet private weak var xCenterConstraintProductView: NSLayoutConstraint!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var editBarButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
      
    var delegate: PropertyVCDelegate?
    var orderDelegate: AddOrderProductDelegate?
    
    private var selectCell: NSInteger = -1

    private var viewModel: ProductVMProtocol = ProductVM()
    private var productInOrder: [ProductInOrder] = []
    
    //MARK: setup searchBar
    private let searchController = UISearchController(searchResultsController: nil)
    private var sortedArray: [Product] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if orderDelegate == nil {
            saveButton.title = ""
        }
        
        authVCPresent()
        
        viewModel.update = tableView.reloadData
        viewModel.loadData(predicate: "")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func reloadTableViewWithSelectedGroup(groupID: String) {
        viewModel.loadData(predicate: groupID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let nc = segue.destination as? SideNC {
            nc.sideMenuDelegate = self
        }
    }

    func setProductsInOrder(products: [ProductInOrder]) {
        self.productInOrder = products
    }
    
    private func authVCPresent() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.showModalAuth()
                print("Mark authvc present")
            } else {
                print("Mark user did auth")
            }
        }
    }
    
    private func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authVC = storyboard.instantiateViewController(withIdentifier: "\(AuthVC.self)") as? AuthVC else { return }
        authVC.modalPresentationStyle = .overFullScreen
        present(authVC, animated: true)
    }
    
    func updateDate(typeId: String, typeName: String) {
        tableView.reloadData()
    }
    
    @IBAction private func editButtonDidTap() {
        didSwipe()
    }
    
    @IBAction func didSwipe() {
        if xCenterConstraintProductView.constant != 0 {
            UIView.animate(withDuration: 0.2) {
                           self.xCenterConstraintSideView.constant -= 250
                           self.xCenterConstraintProductView.constant -= 230
                           self.view.layoutIfNeeded()
                       }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let propertyVC = storyboard.instantiateViewController(withIdentifier: "\(PropertyVC.self)") as? PropertyVC else {return}
            propertyVC.delegate = self
            propertyVC.modalPresentationStyle = .overCurrentContext
            present(propertyVC, animated: false)
        }
    }
    
    @IBAction func didLeftSwipe() {
        if xCenterConstraintProductView.constant == 0 {
            UIView.animate(withDuration: 0.2) {
                self.xCenterConstraintSideView.constant += 250
                self.xCenterConstraintProductView.constant += 230
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setOrderProduct(product: Product, quantity: String) {
        print(Double(product.percentFee))
        var price: Double = 0.0
        product.allPrices.forEach({
            if $0.selfId == ProductVM.typePriceID {
                price = $0.price
            }
        })
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddhhss"
        productInOrder.append(
            ProductInOrder(id: "\(dateFormatter.string(from: Date.now))",
                           productId: product.selfId ?? "",
                           quantity: Int16(quantity) ?? 0,
                           currentBalance: product.quantity,
                           price: price,
                           productName: product.name,
                           fee: Double(product.percentFee))
        )
    }
    
    func showAlert(product: Product) {
        let alert = UIAlertController(title: "Добавить в заказ?", message: "Доступно \(product.quantity) шт", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите количество"
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "Добавить", style: .default, handler: { [weak alert] _ in
            guard let textFields = alert?.textFields else { return }
            if let quantityInOrder = textFields[0].text {
                if product.quantity >= Int16(quantityInOrder) ?? 0 {
                    self.setOrderProduct(product: product, quantity: quantityInOrder)
                    print("Message: Текущий остаток - \(product.quantity)")
                    self.tableView.reloadData()
                } else {
                    self.showErrorAlert(quantity: String(product.quantity), product: product)
                    print("Message: Превышен допустимый остаток")
                    print("Message: Текущий остаток - \(product.quantity)")
                }
                print("Message: Добавлено в заказ - \(quantityInOrder)")
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(quantity: String, product: Product) {
        let alert = UIAlertController(title: "Превышен допустимый остаток", message: "В наличии только \(quantity) шт.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
            self.showAlert(product: product)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction private func saveButtonDidTap() {
        orderDelegate?.setProductInOrder(products: productInOrder)
        orderDelegate?.updateTableView()
        dismiss(animated: true)
    }
    
}
// MARK: - UITableView
extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return sortedArray.count
        }
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if orderDelegate == nil {
            if selectCell == indexPath.row {
                return 200
            } else {
                return ProductTableViewCell.rowHeight
            }
        } else { return ProductTableViewCell.rowHeight }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var product: [Product] = []
        if isFiltering {
            product = sortedArray
        } else {
            product = viewModel.products
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProductTableViewCell.self)", for: indexPath) as? ProductTableViewCell
        cell?.setup(product: product[indexPath.row])
        cell?.delegate = self
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            if orderDelegate != nil {
                tableView.deselectRow(at: indexPath, animated: true)
                showAlert(product: sortedArray[indexPath.row])
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
                if selectCell == indexPath.row {
                    selectCell = -1
                } else {
                    selectCell = indexPath.row
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        } else {
            if orderDelegate != nil {
                tableView.deselectRow(at: indexPath, animated: true)
                showAlert(product: viewModel.products[indexPath.row])
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
                if selectCell == indexPath.row {
                    selectCell = -1
                } else {
                    selectCell = indexPath.row
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
    }
}


// MARK: - extension SerchBar
extension ProductVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ text: String) {
        sortedArray = viewModel.products.filter({ product in
            return product.name.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}

// MARK: - extension SelectedGroupDelegate
extension ProductVC: SelectedGroupDelegate {
    func showSelectGroup(groupID: String) {
        viewModel.loadData(predicate: groupID)
    }
}
