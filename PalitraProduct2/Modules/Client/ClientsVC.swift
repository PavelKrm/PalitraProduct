import UIKit
import AEXML

final class ClientVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var viewModel: ClientsVMProtocol = ClientsVM()
    var delegate: AddOrderDetailClientDelegate?

    // searchBar --------------------------------------------------------------------
    private let searchController = UISearchController(searchResultsController: nil)
    private var sortedClients: [Client] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // ---------- --------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.update = tableView.reloadData
        viewModel.loadDate()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
//MARK: - extension ClientVC, UITableViewDelegate, UITableViewDataSource
extension ClientVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return sortedClients.count
        } else {
            return viewModel.clients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ClientCell.self)", for: indexPath) as? ClientCell
        if isFiltering {
            cell?.setup(client: sortedClients[indexPath.row])
        } else {
            cell?.setup(client: viewModel.clients[indexPath.row])
        }
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let partnerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(PartnerVC.self)") as? PartnerVC else {return}
        if isFiltering {
            partnerVC.delegate = delegate
            partnerVC.setup(client: sortedClients[indexPath.row])
            navigationController?.pushViewController(partnerVC, animated: true)
        } else {
            partnerVC.delegate = delegate
            partnerVC.setup(client: viewModel.clients[indexPath.row])
            navigationController?.pushViewController(partnerVC, animated: true)
        }
    }
    
}
// MARK: - extension SerchBar
extension ClientVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ text: String) {
        sortedClients = viewModel.clients.filter({ client in
            return client.clientName.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}
