import Foundation

struct UsersData: Decodable {
    let totalCount: Int
}

struct UserPreview: Decodable {
    let login: String
    let id: Int
    let avatarUrl: URL
}

struct User: Decodable {
    let avatarUrl: URL
    let name: String
    let email: String
    let company: String
    let following: Int
    let followers: Int
}
