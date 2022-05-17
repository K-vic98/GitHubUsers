import Foundation

fileprivate var currentUserPreviewsCount = 0
fileprivate var lastUploadedUser = 0

fileprivate func calculateIndexPathsToReload(from newUserPreviews: Int) -> [IndexPath] {
    let startIndex = currentUserPreviewsCount - newUserPreviews
    let endIndex = startIndex + newUserPreviews
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
}

final class UserPreviewsPresenter {
    private let usersRepo: UsersRepo
    private weak var userPreviewsView: UserPreviewsView?
    
    init(usersRepo: UsersRepo, userPreviewsView: UserPreviewsView) {
        self.usersRepo = usersRepo
        self.userPreviewsView = userPreviewsView
    }
    
    func getUsers() {
        usersRepo.getUsers(lastUploadedUser: lastUploadedUser)
            .done { [weak self] userPreviews in
                print(lastUploadedUser)
                self?.userPreviewsView?.setUsers(newUsers: userPreviews)
                currentUserPreviewsCount += userPreviews.count
                
                if lastUploadedUser == 0 {
                    self?.userPreviewsView?.updatePresentation(with: .none)
                } else {
                    let indexPathsToReload = calculateIndexPathsToReload(from: userPreviews.count)
                    self?.userPreviewsView?.updatePresentation(with: indexPathsToReload)
                }
                
                guard let lastUserPreview = userPreviews.last else { return }
                lastUploadedUser = lastUserPreview.id
            }
            .catch { [weak self] error in
                self?.userPreviewsView?.reportAboutMistake(mistake: error.localizedDescription)
            }
    }
}

protocol UserPreviewsView: AnyObject {
    func setUsers(newUsers: [UserPreview])
    func updatePresentation(with newIndexPathsToReload: [IndexPath]?)
    func reportAboutMistake(mistake: String)
}
