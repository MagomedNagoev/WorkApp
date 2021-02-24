
import UIKit

class Helper {
    
    static func tamicOff(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    static func addSubviews(superView: UIView, subViews: [UIView]) {
        for view in subViews {
            superView.addSubview(view)
        }
    }
    
}
