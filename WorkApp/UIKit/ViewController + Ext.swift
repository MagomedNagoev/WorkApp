import UIKit

extension UIViewController {
    
    func showAlert(title: String?,
                   message: String?,
                   buttons: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for button in buttons {
            alert.addAction(button)
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

