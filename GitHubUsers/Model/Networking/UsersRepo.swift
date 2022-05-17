import Moya
import PromiseKit

final class UserRepoImplementation: UsersRepo {
    
    private let provider = MoyaProvider<GitHubUsers>()
    
    func getUsers(lastUploadedUser: Int) -> Promise<[UserPreview]> {
        return Promise<[UserPreview]> { [weak self] seal in
            self?.provider.request(.getUsersPreview(lastLoadedUser: lastUploadedUser, usersCount: numberOfUsersPerRequest)) { result in
                switch result {
                    case .success(let response):
                        do {
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            let userPreviews = try jsonDecoder.decode([UserPreview].self, from: response.data)
                            seal.fulfill(userPreviews)
                        } catch {
                            seal.reject(error)
                        }
                    case .failure(let error):
                        seal.reject(error)
                }
            }
        }
    }
    
    func getUser(name: String) -> Promise<UserDescription> {
        return Promise<UserDescription> { [weak self] seal in
            self?.provider.request(.getUser(userName: name)) { result in
                switch result {
                    case .success(let response):
                        do {
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            let user = try jsonDecoder.decode(UserDescription.self, from: response.data)
                            seal.fulfill(user)
                        } catch {
                            seal.reject(error)
                        }
                    case .failure(let error):
                        seal.reject(error)
                }
            }
        }
    }
}

protocol UsersRepo {
    func getUsers(lastUploadedUser: Int) -> Promise<[UserPreview]>
    func getUser(name: String) -> Promise<UserDescription>
}
