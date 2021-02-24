import UIKit

class OrderCell: UITableViewCell {
    
    let cardView = UIView()
    
    let statusLabel = UILabel(text: "New", font: .italicSystemFont(ofSize: 15))
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        Helper.addSubviews(superView: contentView, subViews: [cardView])
        Helper.tamicOff(views: [cardView, titleLabel, priceLabel,statusLabel])
        
        Helper.addSubviews(superView: cardView,
                           subViews: [titleLabel, priceLabel,statusLabel])
        
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
                                     titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)])
        
        NSLayoutConstraint.activate([priceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
                                     priceLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)])
        
        NSLayoutConstraint.activate([statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
                                     statusLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 4)])
        
        
        NSLayoutConstraint.activate([cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
                                     cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
                                     cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                                     cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)])
        
        cardView.layer.cornerRadius = 4
        cardView.backgroundColor = .buttonWhite()
        backgroundColor = .clear
        
        titleLabel.text = "Название задачи"
        priceLabel.text = "4000 руб."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
