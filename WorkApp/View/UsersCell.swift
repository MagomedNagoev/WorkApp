import UIKit

class UsersCell: UICollectionViewCell {
    
    static var reuseId = "UsersCell"
    
    let avatar = UIImageView()
    let nameLabel = UILabel(text: "Name", font: .avenirBold18()!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [avatar, nameLabel],
                                axis: .vertical,
                                spacing: 4)
        
        Helper.addSubviews(superView: self, subViews: [stack])
        Helper.tamicOff(views: [stack, avatar, nameLabel])
        
        nameLabel.textAlignment = .center
        
        backgroundColor = .white
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        avatar.image = UIImage(named: "user")
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([avatar.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: -30)])
        NSLayoutConstraint.activate([nameLabel.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 0),
                                     nameLabel.centerXAnchor.constraint(equalTo: stack.centerXAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
