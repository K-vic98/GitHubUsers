import Foundation
import PromiseKit

final class UserPreviewsPresenter {
    private let usersRepo: UsersRepo?
    private weak var userPreviewsView: UserPreviewsView?
    
    private var currentUserPreviewsCount = 0
    private var lastUploadedUserID = 0
    private var getUsersRequests = [Int: Promise<[UserPreview]>]()
    
    init(userPreviewsView: UserPreviewsView) {
        self.usersRepo = container.resolve(UsersRepo.self)
        self.userPreviewsView = userPreviewsView
    }
    
    func needDataUpdate() {
        guard getUsersRequests[lastUploadedUserID] == nil else { return }
        
        guard let usersRepo = usersRepo else {
            print("Missing userRepo")
            return
        }
        
        let promise = usersRepo.getUsers(lastUploadedUser: lastUploadedUserID)
        
        getUsersRequests[lastUploadedUserID] = promise
        
        promise
            .done { [weak self] userPreviews in
                self?.userPreviewsView?.setUsersData(newUsers: userPreviews)
                self?.currentUserPreviewsCount += userPreviews.count
                
                if self?.lastUploadedUserID == 0 {
                    self?.userPreviewsView?.updatePresentation(with: .none)
                } else {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: userPreviews.count)
                    self?.userPreviewsView?.updatePresentation(with: indexPathsToReload)
                }
                
                guard let lastUserPreview = userPreviews.last else { return }
                self?.lastUploadedUserID = lastUserPreview.id
            }
            .ensure {
                self.getUsersRequests.removeValue(forKey: self.lastUploadedUserID)
            }
            .catch { [weak self] error in
                self?.userPreviewsView?.reportAboutError(error: error.localizedDescription)
            }
    }
    
    func needShowUserDescription(userNumber: Int) {
        userPreviewsView?.showUserDescription(userNumber: userNumber)
    }
    
    func needReset() {
        currentUserPreviewsCount = 0
        lastUploadedUserID = 0
        getUsersRequests.removeAll()
        
        userPreviewsView?.resetUsersData()
    }
    
    private func calculateIndexPathsToReload(from newUserPreviews: Int) -> [IndexPath] {
        let startIndex = currentUserPreviewsCount - newUserPreviews
        let endIndex = startIndex + newUserPreviews
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

protocol UserPreviewsView: ErrorView {
    func setUsersData(newUsers: [UserPreview])
    func resetUsersData()
    func updatePresentation(with newIndexPathsToReload: [IndexPath]?)
    func showUserDescription(userNumber: Int)
}
