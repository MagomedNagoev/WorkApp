//
//  MyOrdersViewController.swift
//  WorkApp
//
//  Created by Нагоев Магомед on 23.11.2020.
//

import UIKit

class MyOrdersViewController: UIViewController, MyOrdersViewControllerDelegate {

    var refreshControl : UIRefreshControl!
   
    var menuBar = UIView()
    let mwUser: MWUser
    let tableView = UITableView()
    var orders = [MWOrder]()
    var titleMyOrdersLabel = UILabel(text: "Мои заказы", font: .avenir(size: 18)!)
    let menuButton = UIButton(title: "",
                              backgroundColor: .buttonBlue(),
                              cornerRadius: 16,
                              tintColor: .white)
    init(currentUser: MWUser){
        self.mwUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        print("viewDidLoad")
        interfaceConfig()
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()

    }

    func reload() {
        getOrders ()
    }

    
    func getOrders () {
        FirestoreService.shared.getOrders { (result) in
            switch result {
            case .success(let orders):
                self.orders = [MWOrder]()
                for order in orders {
                    if order.clientId == self.mwUser.id {
                        self.orders.append(order)
                    }
                }

                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
}

extension MyOrdersViewController {
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
        titleMyOrdersLabel.textColor = .white
        Helper.addSubviews(superView: view, subViews: [menuBar,tableView, titleMyOrdersLabel])
        Helper.tamicOff(views: [menuBar,tableView, titleMyOrdersLabel])
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([menuBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                                     menuBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
                                     menuBar.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                                     menuBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                             tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                                             tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                                             tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 120) ])
        
        NSLayoutConstraint.activate([
                                     titleMyOrdersLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
                                     titleMyOrdersLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor) ])


    }
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        
        cell.titleLabel.text = orders[indexPath.row].title
        cell.priceLabel.text = "\(orders[indexPath.row].price) руб."
        cell.statusLabel.text = orders[indexPath.row].status

        
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
        let vc = ShowOrderViewController(user: self.mwUser, order: orders[indexPath.row])
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completion) in
            FirestoreService.shared.removeOrder(orderId: self.orders[indexPath.row].id) { (result) in
                switch result {
                
                case .success(_):
                    self.getOrders()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        let refuseAction = UIContextualAction(style: .destructive, title: "Отменить") { (_, _, completion) in
            let order = self.orders[indexPath.row]
            FirestoreService.shared.saveOrder(id: order.id, title: order.title, description: order.description, clientId: order.clientId, executorId: "", price: order.price, category: order.category, status: OrderStatus.new.rawValue) { (result) in
                switch result {
                
                case .success(_):
                    self.getOrders()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        let backAction = UIContextualAction(style: .destructive, title: "Вернуть") { (_, _, completion) in
            let order = self.orders[indexPath.row]
            FirestoreService.shared.saveOrder(id: order.id, title: order.title, description: order.description, clientId: order.clientId, executorId: order.executorId, price: order.price, category: order.category, status: OrderStatus.inWork.rawValue) { (result) in
                switch result {
                
                case .success(_):
                    self.getOrders()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        let completeAction = UIContextualAction(style: .destructive, title: "Принять") { (_, _, completion) in
            let order = self.orders[indexPath.row]
            FirestoreService.shared.saveOrder(id: order.id, title: order.title, description: order.description, clientId: order.clientId, executorId: order.executorId, price: order.price, category: order.category, status: OrderStatus.comlete.rawValue) { (result) in
                switch result {
                
                case .success(_):
                    self.getOrders()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        let editAction = UIContextualAction(style: .destructive, title: "") { (_, _, completion) in
            let vc = EditOrderViewController(order: self.orders[indexPath.row], user: self.mwUser)
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
        }
        editAction.backgroundColor = .orange
        deleteAction.backgroundColor = .red
        refuseAction.backgroundColor = .orange
        completeAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        backAction.image = UIImage().resizeImage(systemName: "arrow.counterclockwise")
        deleteAction.image = UIImage().resizeImage(systemName: "trash")
        editAction.image = UIImage().resizeImage(systemName: "doc.badge.gearshape")
        refuseAction.image = UIImage().resizeImage(systemName: "xmark")
        completeAction.image = UIImage().resizeImage(systemName: "checkmark")

        switch self.orders[indexPath.row].status {
        case OrderStatus.new.rawValue:
            return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        case OrderStatus.inWork.rawValue:
            return UISwipeActionsConfiguration(actions: [refuseAction])
        case OrderStatus.check.rawValue:
            return UISwipeActionsConfiguration(actions: [backAction,completeAction])
        case OrderStatus.comlete.rawValue:
            return UISwipeActionsConfiguration(actions: [])
        default:
            return UISwipeActionsConfiguration(actions: [])
        }
        
    }
    
}


