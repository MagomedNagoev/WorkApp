
import UIKit

class PersonView: UIView {
    
    var typeLabel: UILabel = UILabel(text: "Type", font: .avenirBold18()!)
    let nameLabel: UILabel = UILabel(text: "Name", font: .avenir18()!)
    
    init(frame: CGRect, type: PersonType, userName: String) {
        super.init(frame: frame)
        typeLabel.text = type.rawValue
        typeLabel.textColor = .black
        nameLabel.text = userName
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}

//MARK: SetupConstraints
extension PersonView {
    
    func setupConstraints() {
        

        
        let stack = UIStackView(arrangedSubviews: [typeLabel, nameLabel], axis: .vertical, spacing: 5)
        
        Helper.tamicOff(views: [typeLabel, nameLabel, stack])
//        Helper.addSubviews(superView: self, subviews: [typeLabel, nameLabel])
        Helper.addSubviews(superView: self, subViews: [stack])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)])
        
    }
    
}
