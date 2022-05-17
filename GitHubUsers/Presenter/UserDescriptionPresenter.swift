final class UserDescriptionPresenter {
    private let usersRepo: UsersRepo?
    private weak var userDescriptionView: UserDescriptionView?
    
    init(userDescriptionView: UserDescriptionView) {
        self.usersRepo = container.resolve(UsersRepo.self)
        self.userDescriptionView = userDescriptionView
    }
    
    func needDataUpdate(for login: String) {
        guard let usersRepo = usersRepo else { return }
        
        usersRepo.getUser(name: login)
            .done { [weak self] userDescription in
                self?.userDescriptionView?.setAndUpdateUserData(newUser: userDescription)
            }
            .catch { [weak self] error in
                self?.userDescriptionView?.reportAboutError(error: error.localizedDescription)
            }
    }
}

protocol UserDescriptionView: ErrorView {
    func setAndUpdateUserData(newUser: UserDescription)
}
