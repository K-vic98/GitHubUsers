import Foundation
import PromiseKit

fileprivate var currentUserPreviewsCount = 0
fileprivate var lastUploadedUser = 0
fileprivate var getUsersRequests = [Int: Promise<[UserPreview]>]()

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
        guard getUsersRequests[lastUploadedUser] == nil else { return }
        
        let promise = usersRepo.getUsers(lastUploadedUser: lastUploadedUser)
        
        getUsersRequests[lastUploadedUser] = promise
        
        promise
            .done { [weak self] userPreviews in
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
            .ensure {
                getUsersRequests.removeValue(forKey: lastUploadedUser)
            }
            .catch { [weak self] error in
                self?.userPreviewsView?.reportAboutMistake(mistake: error.localizedDescription)
            }
    }
    
    func reset() {
        currentUserPreviewsCount = 0
        lastUploadedUser = 0
    }
}

protocol ErrorView: AnyObject {
    func reportAboutMistake(mistake: String)
}

protocol UserPreviewsView: ErrorView {
    func setUsers(newUsers: [UserPreview])
    func updatePresentation(with newIndexPathsToReload: [IndexPath]?)
}
