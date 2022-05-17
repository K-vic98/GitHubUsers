import UIKit
import TinyConstraints

final class UserPreviewsViewController: UITableViewController {
    private lazy var userPreviewsPresenter = UserPreviewsPresenter(usersRepo: container.resolve(UsersRepo.self)!,
                                                                   userPreviewsView: self)
    
    private let loadingView = LoadingView()
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeInitialSetup()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.register(cellType: UserPreviewCell.self)
        
        userPreviewsPresenter.getUsers()
    }
    
    private func makeInitialSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Users"
        view.backgroundColor = appColor
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = 100
        
        view.addSubview(loadingView)
        loadingView.edgesToSuperview(usingSafeArea: true)
    }
    
    @objc private func refresh() {
        userPreviews.removeAll()
        userPreviewsPresenter.reset()
        tableView.refreshControl?.endRefreshing()
    }
}

extension UserPreviewsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPreviewsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPreviewCell: UserPreviewCell = tableView.dequeueReusableCell(for: indexPath)
        if isLoadingCell(for: indexPath) {
            userPreviewCell.configure(with: .none)
        } else {
            userPreviewCell.configure(with: userPreviews[indexPath.item])
        }
        
        return userPreviewCell
    }
}

extension UserPreviewsViewController {
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
        {
            let userDescriptionController = UserDescriptionViewController()
            userDescriptionController.currentUserName = userPreviews[indexPath.row].login
            navigationController?.pushViewController(userDescriptionController, animated: true)
        }
}

extension UserPreviewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            userPreviewsPresenter.getUsers()
        }
    }
}

extension UserPreviewsViewController: UserPreviewsView {
    func reportAboutMistake(mistake: String) {
        let alert = UIAlertController(title: "Warning", message: mistake, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func setUsers(newUsers: [UserPreview]) {
        userPreviews += newUsers
    }
    
    func updatePresentation(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            loadingView.removeFromSuperview()
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
}

private extension UserPreviewsViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= userPreviews.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        
        return Array(indexPathsIntersection)
    }
}
