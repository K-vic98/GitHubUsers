import UIKit

class UserPreviewsViewController: UIViewController {
    lazy var userPreviewsPresenter = UserPreviewsPresenter(userPreviewsService: UserPreviewsService(), userPreviewsView: self)
    
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UserPreviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension UserPreviewsViewController: UserPreviewsView {
    func setUsers(users: [UserPreview]) {
        userPreviews += users
    }
}
