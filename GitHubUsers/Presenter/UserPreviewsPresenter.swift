protocol UserPreviewsView: AnyObject {
    func setUsers(users: [UserPreview])
}

final class UserPreviewsPresenter {
    private let userPreviewsService: UserPreviewsService
    private weak var userPreviewsView: UserPreviewsView?
    
    init(userPreviewsService: UserPreviewsService, userPreviewsView: UserPreviewsView) {
        self.userPreviewsService = userPreviewsService
        self.userPreviewsView = userPreviewsView
    }
    
    func getUsers() {
        userPreviewsService.getUsers { [weak self] users in
            self?.userPreviewsView?.setUsers(users: users)
        }
    }
}
