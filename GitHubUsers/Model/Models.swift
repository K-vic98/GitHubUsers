import Foundation

struct UserPreview: Decodable {
    let login: String
    let id: Int
    let avatarUrl: URL
}
