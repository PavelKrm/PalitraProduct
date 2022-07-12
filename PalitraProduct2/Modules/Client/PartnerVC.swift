import Foundation
import UIKit

final class PartnerVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var client: Client!
    private var partner: Partner!

    var delegate: AddOrderDetailClientDelegate?
    
    // searchBar --------------------------------------------------------------------
    private let searchController = UISearchController(searchResultsController: nil)
    private var sortedPartners: [Partner] = []
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setup(client: Client) {
        self.client = client
    }
    
    
}

extension PartnerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return sortedPartners.count
        } else {
            return client.allPartner.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ClientCell.self)", for: indexPath) as? ClientCell
        if isFiltering {
            cell?.setup(partner: sortedPartners[indexPath.row])
        } else {
        cell?.setup(partner: client.allPartner[indexPath.row])
        }
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering {
            partner = sortedPartners[indexPath.row]
        } else {
            partner = client.allPartner[indexPath.row]
        }
        delegate?.setOrder(client: client, partner: partner)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - extension SerchBar
extension PartnerVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ text: String) {
        sortedPartners = client.allPartner.filter({ partner in
            return partner.name.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}
