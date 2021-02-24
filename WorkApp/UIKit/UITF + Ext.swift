import UIKit

extension UITextField {
    convenience init(backgroundColor: UIColor,
                     cornerRadius: CGFloat,
                     placeholder: String) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.placeholder = placeholder
        frame.size.height = 30
        
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: 5, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
    func standardTF () {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
    
}
extension UITextView {

    func standardTF () {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
    
}
