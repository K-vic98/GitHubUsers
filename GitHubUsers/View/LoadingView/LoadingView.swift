import UIKit

final class LoadingView: UIView {
    let activityIndicator = UIActivityIndicatorView()
    
    override func layoutSubviews() {
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
    }
}
