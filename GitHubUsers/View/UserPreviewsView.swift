import UIKit
import TinyConstraints

class UserPreviewsViewController: UIViewController {
    lazy var userPreviewsPresenter = UserPreviewsPresenter(userPreviewsService: UserPreviewsService(), userPreviewsView: self)
    
    private let tableView = UITableView()
    private let loadingView = LoadingView()
    private var userPreviews = [UserPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        tableView.dataSource = self
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(loadingView)
        
        tableView.edgesToSuperview(usingSafeArea: true)
        loadingView.edgesToSuperview(usingSafeArea: true)
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
