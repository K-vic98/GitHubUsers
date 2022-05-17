import UIKit
import TinyConstraints

final class LoadingView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func layoutSubviews() {
        makeInitialSetup()
    }
    
    private func makeInitialSetup() {
        backgroundColor = .systemBackground
        
        addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        activityIndicator.edgesToSuperview(usingSafeArea: true)
    }
}
