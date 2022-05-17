import UIKit
import Reusable

final class UserView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with userPreview: UserDescription) {
        avatarImage.kf.setImage(with: userPreview.avatarUrl)
        nameLabel.text = userName + userPreview.name
        emailLabel.text = userEmail + (userPreview.email ?? "")
        companyLabel.text = userCompany + (userPreview.company ?? "")
        followingLabel.text = userFollowing + String(userPreview.following)
        followersLabel.text = userFollowers + String(userPreview.followers)
    }
}
