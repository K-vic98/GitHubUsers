import UIKit

extension UIViewController {
    func showError(error description: String) {
        let alert = UIAlertController(title: "Warning", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true)
    }
}
