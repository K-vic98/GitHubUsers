import UIKit
import TinyConstraints

class UserPreviewsViewController: UIViewController {
    lazy var userPreviewsPresenter = UserPreviewsPresenter(usersRepo: UserRepoImplementation(), userPreviewsView: self)
    
    private let tableView = UITableView()
    private let loadingView = LoadingView()
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        tableView.dataSource = self
        
        tableView.register(cellType: UserPreviewCell.self)
        userPreviewsPresenter.getUsers()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
        tableView.rowHeight = 100
        view.addSubview(loadingView)
        loadingView.edgesToSuperview(usingSafeArea: true)
    }
}

extension UserPreviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPreviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPreviewCell: UserPreviewCell = tableView.dequeueReusableCell(for: indexPath)
        userPreviewCell.configure(with: userPreviews[indexPath.item])
        
        return userPreviewCell
    }
}

extension UserPreviewsViewController: UserPreviewsView {
    func setUsers(users: [UserPreview]) {
        if loadingView.superview != nil {
            loadingView.removeFromSuperview()
        }
        
        userPreviews += users
        tableView.reloadData()
    }
}
