final class UserDescriptionPresenter {
    private let usersRepo: UsersRepo
    private weak var userDescriptionView: UserDescriptionView?
    
    init(usersRepo: UsersRepo, userDescriptionView: UserDescriptionView) {
        self.usersRepo = usersRepo
        self.userDescriptionView = userDescriptionView
    }
    
    func getUser(for login: String) {
        print(login)
        usersRepo.getUser(name: login)
            .done { [weak self] userDescription in
                self?.userDescriptionView?.setUser(newUser: userDescription)
            }
            .catch { [weak self] error in
                self?.userDescriptionView?.reportAboutMistake(mistake: error.localizedDescription)
            }
    }
}

protocol UserDescriptionView: ErrorView {
    func setUser(newUser: UserDescription)
}
