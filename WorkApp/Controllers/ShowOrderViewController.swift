import UIKit

class ShowOrderViewController: UIViewController {
    

    
    private var currentUser: MWUser
    private var order: MWOrder
    private var orderer = MWUser(username: "", id: "", email: "", avatarUrl: "", description: "", gender: "", phone: "")
    
    var ordererView = PersonView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)), type: .orderer, userName: "ordererName")
    var executorView = PersonView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)), type: .executor, userName: "executorName")
    var categoryLabel = UILabel(text: "title", font: .avenir(size: 26)!)
    var titleLabel = UILabel(text: "title", font: .avenirBold28()!)
    var descriptionTV = UITextView()
    var priceLabel = UILabel(text: "price", font: .avenir26()!)
    var responseButton = UIButton(title: "Откликнуться", backgroundColor: .buttonBlue(), cornerRadius: 6, tintColor: .white)
    
    init(user: MWUser, order: MWOrder) {
        
        self.currentUser = user
        self.order = order
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(order.description)
        print(currentUser.username)
        view.backgroundColor = .buttonWhite()
        setupConstraints()
        addContent()
        getUserData()
        getOrderData()
        responseButton.addTarget(self, action: #selector(responseTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: AddContent
    
    func addContent() {
        categoryLabel.text = order.category
        titleLabel.text = order.title
        titleLabel.adjustsFontSizeToFitWidth = true
        descriptionTV.text = order.description
        priceLabel.text = "\(order.price) руб."
    }
    
    func getUserData() {
        FirestoreService.shared.getUserForId(userId: order.clientId) { (result) in
            switch result {
            
            case .success(let client):
                self.orderer = client
                self.ordererView.nameLabel.text = client.username
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getOrderData() {
        guard order.executorId != "" else {
            self.executorView.nameLabel.text = "-"
            return
        }
        FirestoreService.shared.getUserForId(userId: order.executorId) { (result) in
            switch result {
            
            case .success(let client):
                self.orderer = client
                self.executorView.nameLabel.text = client.username
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func responseTapped() {
        guard order.executorId == "" else {
            self.dismiss(animated: true, completion: nil)

            return
        }
        
        guard order.clientId != currentUser.id else {
            self.dismiss(animated: true, completion: nil)

            return
        }
        FirestoreService.shared.saveOrder(id: order.id, title: order.title, description: order.description, clientId: order.clientId, executorId: currentUser.id, price: order.price, category: order.category, status: OrderStatus.inWork.rawValue) { (result) in
            switch result {
            
            case .success(_):
                self.executorView.nameLabel.text = self.currentUser.username
                self.dismiss(animated: true, completion: nil)
                print("OK")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //        self.dismiss(animated: true, completion: nil)
}






// MARK: SetupConstraints

extension ShowOrderViewController {
    
    func setupConstraints() {
        if order.executorId != "" || order.clientId == currentUser.id {
            responseButton.setTitle("Закрыть", for: .normal)
        }
        titleLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        categoryLabel.textAlignment = .center
        responseButton.titleLabel?.font = .avenir26()!
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel,categoryLabel, priceLabel], axis: .vertical, spacing: 24)
        let stackView = UIStackView(arrangedSubviews: [descriptionTV, ordererView, executorView, responseButton], axis: .vertical, spacing: 16)
        
        Helper.tamicOff(views: [ordererView, executorView, titleLabel, descriptionTV, priceLabel, responseButton, stackView, titleStackView])
        Helper.addSubviews(superView: view, subViews: [stackView, titleStackView])
        descriptionTV.font = .avenir20()

        ordererView.layer.cornerRadius = 6
        executorView.layer.cornerRadius = 6
        descriptionTV.layer.cornerRadius = 6
        descriptionTV.isEditable = false
        
        NSLayoutConstraint.activate([titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([responseButton.heightAnchor.constraint(equalToConstant: 60)])
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)])
        
        
    }
}
