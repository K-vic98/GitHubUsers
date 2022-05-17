import UIKit
import TinyConstraints

final class UserDescriptionViewController: UIViewController {
    
    private let userView = UserView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let loadingView = LoadingView()
    var currentUserName = ""
    
    private lazy var userDescriptionPresenter = UserDescriptionPresenter(usersRepo: container.resolve(UsersRepo.self)!, userDescriptionView: self)
    
    override func viewDidLoad() {
        makeInitialSetup()
        userDescriptionPresenter.getUser(for: currentUserName)
    }
    
    private func makeInitialSetup() {
        view.backgroundColor = appColor
        
        view.addSubview(userView)
        userView.edgesToSuperview(usingSafeArea: true)
        
        view.addSubview(loadingView)
        loadingView.edgesToSuperview(usingSafeArea: true)
    }
}

extension UserDescriptionViewController: UserDescriptionView {
    func setUser(newUser: UserDescription) {
        loadingView.removeFromSuperview()
        userView.configure(with: newUser)
    }
    
    func reportAboutMistake(mistake: String) {
        let alert = UIAlertController(title: "Warning", message: mistake, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true)
    }
}
