import UIKit

final class UserPreviewCell: UITableViewCell {
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
        
        //avatar.image = .none
        login.text = userPreview.login
        id.text = String(userPreview.id)
        activityIndicator.stopAnimating()
    }
}
