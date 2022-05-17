import UIKit
import TinyConstraints
import Reusable

final class UserDescriptionViewController: UIViewController {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    var currentUserName = ""
    
    private lazy var userDescriptionPresenter = UserDescriptionPresenter(userDescriptionView: self)
    
    override func viewDidLoad() {
        makeInitialSetup()
        userDescriptionPresenter.needDataUpdate(for: currentUserName)
    }
    
    private func makeInitialSetup() {
        view.backgroundColor = appColor
        
        view.addSubview(loadingIndicator)
        loadingIndicator.edgesToSuperview(usingSafeArea: true)
        loadingIndicator.hidesWhenStopped = true
    }
}

extension UserDescriptionViewController: UserDescriptionView {
    
    func reportAboutError(error: String) {
        self.showError(error: error)
    }
    
    func setAndUpdateUserData(newUser: UserDescription) {
        
        avatarImage.kf.setImage(with: newUser.avatarUrl)
        nameLabel.text = userName + (newUser.name ?? missing)
        emailLabel.text = userEmail + (newUser.email ?? missing)
        companyLabel.text = userCompany + (newUser.company ?? missing)
        followingLabel.text = userFollowing + String(newUser.following)
        followersLabel.text = userFollowers + String(newUser.followers)
        
        loadingIndicator.stopAnimating()
    }
}
