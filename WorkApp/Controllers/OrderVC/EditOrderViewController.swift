import UIKit
protocol MyOrdersViewControllerDelegate {
    func reload()
}
class EditOrderViewController: UIViewController {
    var delegate: MyOrdersViewControllerDelegate?
    let orderView = OrderView()
    private let user: MWUser
    private let order: MWOrder

    init(order: MWOrder, user: MWUser) {
        self.user = user
        self.order = order
        orderView.descTV.text = order.description
        orderView.costTF.text = String(order.price)
        orderView.titleTF.text = order.title
        orderView.categoryTF.text = order.category
        super.init(nibName: nil, bundle: nil)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = orderView
        addTargets()

    }

}

extension EditOrderViewController {
    
    func addTargets() {
        orderView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    
    @objc func saveTapped() {

        FirestoreService.shared.saveOrder(id: order.id, title: orderView.titleTF.text!, description: orderView.descTV.text, clientId: order.clientId, executorId: order.executorId, price: Int(orderView.costTF.text!) ?? 0, category: orderView.categoryTF.text!, status: order.status) { (result) in
            
            switch result {
            
            case .success(let order):
                
                let alert = UIAlertController(title: "Поздравляю!", message: "Ваш заказ \(order.title) изменен!", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.delegate?.reload()

                    self.dismiss(animated: true, completion: nil)
                }

                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)


            case .failure(let error):
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                }
                self.showAlert(title: "Ошибка!", message: error.localizedDescription, buttons: [okAction])
                
            }
        }
        
    }
}


