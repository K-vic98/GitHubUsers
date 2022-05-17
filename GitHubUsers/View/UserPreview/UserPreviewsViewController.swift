import UIKit
import TinyConstraints

final class UserPreviewsViewController: UITableViewController {
    private lazy var userPreviewsPresenter = UserPreviewsPresenter(userPreviewsView: self)
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeInitialSetup()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.register(cellType: UserPreviewCell.self)
        
        userPreviewsPresenter.needDataUpdate()
    }
    
    private func makeInitialSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Users"
        view.backgroundColor = appColor
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = cellHeight
        
        view.addSubview(loadingIndicator)
        loadingIndicator.edgesToSuperview(usingSafeArea: true)
        loadingIndicator.hidesWhenStopped = true
    }
    
    @objc private func refresh() {
        userPreviewsPresenter.needReset()
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
        userPreviewsPresenter.needShowUserDescription(userNumber: indexPath.row)
    }
}

extension UserPreviewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            userPreviewsPresenter.needDataUpdate()
        }
    }
}

extension UserPreviewsViewController: UserPreviewsView {
    
    func reportAboutError(error: String) {
        self.showError(error: error)
    }
    
    func setUsersData(newUsers: [UserPreview]) {
        userPreviews += newUsers
    }
    
    func resetUsersData() {
        userPreviews.removeAll()
        tableView.refreshControl?.endRefreshing()
        userPreviewsPresenter.needDataUpdate()
    }
    
    func updatePresentation(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            loadingIndicator.stopAnimating()
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func showUserDescription(userNumber: Int) {
        let userDescriptionController = UserDescriptionViewController() // переделать
        userDescriptionController.currentUserName = userPreviews[userNumber].login
        navigationController?.pushViewController(userDescriptionController, animated: true)
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
