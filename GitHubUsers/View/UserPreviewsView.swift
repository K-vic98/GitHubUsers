import UIKit
import TinyConstraints

final class UserPreviewsViewController: UIViewController {
    lazy var userPreviewsPresenter = UserPreviewsPresenter(usersRepo: UserRepoImplementation(), userPreviewsView: self)
    
    private let tableView = UITableView()
    private let loadingView = LoadingView()
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeInitialSetup()
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(cellType: UserPreviewCell.self)
        
        userPreviewsPresenter.getUsers()
    }
    
    private func makeInitialSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Users"
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
        return userPreviewsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPreviewCell: UserPreviewCell = tableView.dequeueReusableCell(for: indexPath)
        if isLoadingCell(for: indexPath) {
            userPreviewCell.configure(with: .none)
        } else {
            userPreviewCell.configure(with: userPreviews[indexPath.item])
        }
        
        return userPreviewCell
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
