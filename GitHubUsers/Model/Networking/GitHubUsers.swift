import Moya

enum GitHubUsers {
    case getUsersPreview(lastLoadedUser: Int, usersCount: Int)
    case getUser(userName: String)
}

extension GitHubUsers: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
            case .getUsersPreview:
                return "/users"
            case .getUser(let userName):
                return "/users/\(userName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getUsersPreview, .getUser: return .get
        }
    }
    
    var task: Task {
        switch self {
            case .getUsersPreview(let lastLoadedUser, let usersCount):
                return .requestParameters(
                    parameters: ["since": lastLoadedUser, "per_page": usersCount],
                    encoding: URLEncoding.queryString)
            case .getUser: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
