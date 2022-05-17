import UIKit
import Reusable
import Kingfisher

final class UserPreviewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(with userPreview: UserPreview?) {
        guard let userPreview = userPreview else {
            avatarImage.image = .none
            loginLabel.text = ""
            idLabel.text = ""
            activityIndicator.startAnimating()
            return
        }
        
        accessoryType = .detailButton
        avatarImage.kf.setImage(with: userPreview.avatarUrl)
        loginLabel.text = userPreview.login
        idLabel.text = String(userPreview.id)
        activityIndicator.stopAnimating()
    }
}
