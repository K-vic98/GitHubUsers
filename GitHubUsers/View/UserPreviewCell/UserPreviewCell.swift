import UIKit
import Kingfisher
import Reusable

final class UserPreviewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var login: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(with userPreview: UserPreview?) {
        
        guard let userPreview = userPreview else {
            avatar.image = .none
            login.text = ""
            id.text = ""
            activityIndicator.startAnimating()
            return
        }
        accessoryType = .detailButton
        avatar.kf.setImage(with: userPreview.avatarUrl, placeholder: ActivityPlaceholder())
        login.text = userPreview.login
        id.text = String(userPreview.id)
        activityIndicator.stopAnimating()
    }
}

final class ActivityPlaceholder: Placeholder {
    func add(to imageView: KFCrossPlatformImageView) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func remove(from imageView: KFCrossPlatformImageView) {
        (imageView.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView)?.removeFromSuperview()
    }
}
