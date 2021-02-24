import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UIViewController {
    
    var mwUser: MWUser
    var filteredOrders = [MWOrder]()
    
    private var ordersListener: ListenerRegistration?
    
    var orders = [MWOrder]()
    
//    let cat: UICollectionView!
    let searchBar = UISearchBar()
    
    var menuBar = UIView()
        
    let logoutButton = UIButton(title: "",
                                backgroundColor: .buttonBlue() ,
                                cornerRadius: 16,
                                tintColor: .white)
    
    let menuButton = UIButton(title: "",
                              backgroundColor: .buttonBlue(),
                              cornerRadius: 16,
                              tintColor: .white)
    
    let addOrderButton = UIButton(title: "Разместить заказ",
                                  backgroundColor: .buttonBlue(),
                                  cornerRadius: 4,
                                  tintColor: .white)
    
    let tableView = UITableView()
    
    let label = UILabel(text: "", font: UIFont(name:"avenir", size: 18)!)
    
    var refreshControl : UIRefreshControl!


    init(mwUser: MWUser) {
        
        self.mwUser = mwUser
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        interfaceConfig()
        addTargets()
        setupListener()
        navigationController?.navigationBar.isHidden = true
        setapSearchBar()
        hideKeyboardOnTap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
        getUserData()

    }
    
    func setupListener() {
        ordersListener = ListenerService.shared.ordersObderve(orders: orders, completion: { (result) in
            switch result {
            // добавить проверку на статусы
            case .success(let orders):
//                order.executorId == "" && order.status == OrderStatus.new.rawValue && order.clientId != self.mwUser.id
                self.orders = orders.filter({$0.status == OrderStatus.new.rawValue && $0.executorId == "" && $0.clientId != self.mwUser.id})
                self.filteredOrders = self.orders
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }


}

//MARK: AddConstraints
extension MainViewController {
    
    func getUserData() {
        FirestoreService.shared.getUserData(user: FirebaseAuth.Auth.auth().currentUser!) {  (result) in
            switch result {
            
            case .success(let mwuser):
                self.mwUser = mwuser
                print(self.mwUser.username)
                self.label.text = self.mwUser.username
            case .failure(let error):
                print("FailureData: \(error.localizedDescription)")
            }
        }
    }
    
    
    func getOrders () {
        FirestoreService.shared.getOrders { (result) in
            switch result {
            case .success(let orders):
                self.orders = [MWOrder]()
                for order in orders {
                    if order.executorId == "" && order.status == OrderStatus.new.rawValue && order.clientId != self.mwUser.id {
                        self.orders.append(order)
                        
                    }
                }
                print(self.orders.count)
                print(self.filteredOrders.count)
                self.filteredOrders = self.orders
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }

    @objc func enlargeTable() {

        getOrders()
        refreshControl.endRefreshing()
    }

    func interfaceConfig() {
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(enlargeTable), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderCell.self, forCellReuseIdentifier: "OrderCell")
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
        
        menuBar.backgroundColor = .buttonBlue()
        label.textColor = .white
        
        logoutButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        menuButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        Helper.tamicOff(views: [menuBar,
                                logoutButton,
                                tableView,
                                searchBar,
                                label,
                                menuButton,
                                addOrderButton
        ])
        
        Helper.addSubviews(superView: view, subViews: [menuBar,
                                                       logoutButton,
                                                       tableView,
                                                       searchBar,
                                                       label,
                                                       addOrderButton,
                                                       menuButton])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([logoutButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
                                     logoutButton.topAnchor.constraint(equalTo: menuBar.topAnchor, constant: 0),
                                     logoutButton.heightAnchor.constraint(equalToConstant: 50),
                                     logoutButton.widthAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([menuButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
                                     menuButton.topAnchor.constraint(equalTo: menuBar.topAnchor, constant: 0),
                                     menuButton.heightAnchor.constraint(equalToConstant: 50),
                                     menuButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([menuBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                                     menuBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
                                     menuBar.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                                     menuBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        NSLayoutConstraint.activate([label.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
                                     label.centerXAnchor.constraint(equalTo: guide.centerXAnchor)])
        
        NSLayoutConstraint.activate([tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                             tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                             tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                             tableView.topAnchor.constraint(equalTo: addOrderButton.bottomAnchor, constant: 20) ])
        
        NSLayoutConstraint.activate([addOrderButton.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 70),
                                     addOrderButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 40),
                                     addOrderButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                                     addOrderButton.heightAnchor.constraint(equalToConstant: 40)
                                     
                                     
        ])
        
        NSLayoutConstraint.activate([searchBar.bottomAnchor.constraint(equalTo: addOrderButton.topAnchor, constant: -12),
                                     searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                     searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                     searchBar.heightAnchor.constraint(equalToConstant: 50)
                                     
                                     
        ])
    }

}

//MARK: AddTargets
extension MainViewController {
    
    func addTargets() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        addOrderButton.addTarget(self, action: #selector(addOrderTapped), for: .touchUpInside)
        
    }
    
    @objc func logoutTapped() {
        
        try! AuthService.shared.auth.signOut()
        
        let vc = SignInViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func menuTapped() {
        StorageService.shared.download(url: mwUser.id) { (result) in
            switch result {
            
            case .success(let data):
                let vc = SpecViewController(currentUser: self.mwUser, isEdit: true)
                vc.avatarImageView.image.image = UIImage(data: data)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                let vc = SpecViewController(currentUser: self.mwUser, isEdit: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        

    }
    
    @objc func addOrderTapped() {
        
        let vc = NewOrderViewController(user: mwUser)
        present(vc, animated: true, completion: nil)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = filteredOrders[indexPath.row].title
        cell.priceLabel.text = "\(filteredOrders[indexPath.row].price) руб."
        cell.statusLabel.text = filteredOrders[indexPath.row].status
        
        switch cell.statusLabel.text {
        case OrderStatus.new.rawValue : cell.statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case OrderStatus.inWork.rawValue : cell.statusLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case OrderStatus.check.rawValue : cell.statusLabel.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        case OrderStatus.comlete.rawValue : cell.statusLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        default:
            cell.statusLabel.textColor = .black
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let vc = ShowOrderViewController(user: self.mwUser, order: filteredOrders[indexPath.row])

        self.present(vc, animated: true, completion: nil)
    }
    

    
}

extension MainViewController {

    
    func hideKeyboardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MainViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


