import UIKit

class NewOrderViewController: UIViewController {
    let orderView = OrderView()
    private let currentUser: MWUser
    let picker = UIPickerView()
    init(user: MWUser) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        self.view = orderView
        orderView.saveButton.setTitle("Создать", for: .normal)

    }

}

extension NewOrderViewController {
    func check() {
        guard orderView.costTF.text != "" || Int(orderView.costTF.text ?? "") != nil else {
            orderView.saveButton.isEnabled = true
            return
        }
        
    }
    func addTargets() {
        orderView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    
    @objc func saveTapped() {
        let orderID = String(describing: UUID.init())

        if let titleText = orderView.titleTF.text, let costText = orderView.costTF.text, let categoryText = orderView.categoryTF.text {
            if let costInt = Int(costText) {
                FirestoreService.shared.saveOrder(id: orderID, title: titleText, description: orderView.descTV.text, clientId: currentUser.id, executorId: nil, price: costInt, category: categoryText, status: OrderStatus.new.rawValue) { (result) in
                    
                    switch result {
                    
                    case .success(let order):
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                            self.showAlert(title: "Поздравляем!", message: "Ваш заказ \(order.title) создан", buttons: [okAction])
                    case .failure(let error):
                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        }
                        self.showAlert(title: "Ошибка!", message: error.localizedDescription, buttons: [okAction])
            
                    }
                }
            }

        }

        
    }
}


