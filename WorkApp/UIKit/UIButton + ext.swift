import UIKit

extension UIButton {
    
    convenience init(title: String,
                     backgroundColor: UIColor,
                     cornerRadius: CGFloat,
                     tintColor: UIColor) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.tintColor = tintColor
        
        frame.size.height = 30
    }

}
