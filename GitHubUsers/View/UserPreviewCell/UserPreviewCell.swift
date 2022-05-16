import UIKit

class UserPreviewCell: UITableViewCell {
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var login: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func fetch(userPreview: UserPreview) {
        login.text = userPreview.login
        id.text = String(userPreview.id)
    }
}
