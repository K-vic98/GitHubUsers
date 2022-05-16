import Foundation

protocol UserPreviewsView: AnyObject {
    func setUsers(users: [UserPreview])
}

final class UserPreviewsPresenter {
    private let usersRepo: UsersRepo
    private weak var userPreviewsView: UserPreviewsView?
    
    init(usersRepo: UsersRepo, userPreviewsView: UserPreviewsView) {
        self.usersRepo = usersRepo
        self.userPreviewsView = userPreviewsView
    }
    
    func getUsers() {
        usersRepo.getUsers()
            .done { [weak self] userPreviews in
                self?.userPreviewsView?.setUsers(users: userPreviews)
            }
    }
}
