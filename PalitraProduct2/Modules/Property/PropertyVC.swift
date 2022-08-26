import UIKit

protocol PropertyVCDelegate {
    func updateDate(typeId: String, typeName: String)
}

class PropertyVC: UIViewController {
    
    @IBOutlet weak var chooseTypePriceLabel: UILabel!
    @IBOutlet weak var nameTypePriceLabel: UILabel!
    @IBOutlet weak var typePricesTV: UITableView!
    @IBOutlet weak var viewAnimate: UIView!
    @IBOutlet weak var xCenterConstraint: NSLayoutConstraint! {
        didSet {
            xCenterConstraint.constant += UIScreen.main.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showaAnimation()
    }
 
    var delegate: PropertyVCDelegate?
    private var viewModel: ProductVMProtocol = ProductVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.update = typePricesTV.reloadData
        viewModel.loadData(predicate: "")
        
        typePricesTV.delegate = self
        typePricesTV.dataSource = self
        setTypePriceNameLabel(array: viewModel.typePrices)
        nameTypePriceLabel.layer.cornerRadius = 5.0
        nameTypePriceLabel.clipsToBounds = true
        chooseTypePriceLabel.clipsToBounds = true
        chooseTypePriceLabel.layer.cornerRadius = 5.0
        viewAnimate.layer.cornerRadius = 10.0
        
    }
    
    private func setTypePriceNameLabel(array: [TypePrice]) {
        array.forEach({
            if $0.id == ProductVM.typePriceID {
                nameTypePriceLabel.text = $0.name
            }
        })
    }
    
    @IBAction func didSwipe() {
        hideAnimation()
    }
}

extension PropertyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.typePrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TypePriceTableViewCell.self)", for: indexPath) as? TypePriceTableViewCell
        cell?.setup(product: viewModel.typePrices[indexPath.row])
        cell?.layer.cornerRadius = 20.0
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ProductVM.typePriceID = viewModel.typePrices[indexPath.row].id
        nameTypePriceLabel.text = viewModel.typePrices[indexPath.row].name
        delegate?.updateDate(typeId: viewModel.typePrices[indexPath.row].id, typeName: viewModel.typePrices[indexPath.row].name)
        dismiss(animated: true)
    }
    
    //MARK: - Animation
    
    private func showaAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.xCenterConstraint.constant -= (UIScreen.main.bounds.width / 2 - 50)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.xCenterConstraint.constant += (UIScreen.main.bounds.width / 2 )
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
}
