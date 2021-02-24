import UIKit

extension MainViewController: UISearchBarDelegate {
    
    func setapSearchBar() {
        searchBar.tintColor = .buttonBlue()
        searchBar.searchTextField.textColor = .buttonBlue()
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.searchTextField.tintColor = .buttonBlue()
        searchBar.searchTextField.leftView?.tintColor = .buttonBlue()
        searchBar.searchTextField.placeholder = "Поиск по заказам"
    }
    
    func reloadData (with searchText: String?) {
        if let text = searchText {
            let filtered = orders.filter { (order) -> Bool in
                order.title.lowercased().contains(text.lowercased())
            }
            

            if text == "" {
                filteredOrders = orders

            } else {
                filteredOrders = filtered
            }
        }
        tableView.reloadData()

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
}
