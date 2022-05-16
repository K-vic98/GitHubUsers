import UIKit

class UserPreviewsViewController: UIViewController {
    lazy var userPreviewsPresenter = UserPreviewsPresenter(userPreviewsService: UserPreviewsService(), userPreviewsView: self)
    
    private let tableView = UITableView()
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // register tableViewCell
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
