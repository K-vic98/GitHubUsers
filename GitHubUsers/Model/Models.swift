import Foundation

struct UsersData: Decodable {
    let totalCount: Int
}

struct UserPreview: Decodable {
    let login: String
    let id: Int
    let avatarUrl: URL
}
