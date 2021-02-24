import UIKit

class AvatarView: UIView {
    
    var image: UIImageView
    
    override init(frame: CGRect) {
        self.image = UIImageView()
        super.init(frame: frame)
        
        Helper.tamicOff(views: [image])
        Helper.addSubviews(superView: self, subViews: [image])
        
        NSLayoutConstraint.activate([image.topAnchor.constraint(equalTo: self.topAnchor),
                                     image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     image.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
