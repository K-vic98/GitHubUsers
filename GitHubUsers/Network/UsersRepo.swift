import Moya
import PromiseKit

fileprivate let numberOfUsersPerRequest = 30

protocol UsersRepo {
    func getUsers() -> Promise<[UserPreview]>
    func getTotalUsersCount() -> Promise<Int>
}

final class UserRepoImplementation: UsersRepo {
    
    private let provider = MoyaProvider<GitHubUsers>()
    
    func getUsers() -> Promise<[UserPreview]> {
        return Promise<[UserPreview]> { [weak self] seal in
            self?.provider.request(.getUsersPreview(lastLoadedUser: 0, usersCount: numberOfUsersPerRequest)) { result in
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
    
    func getTotalUsersCount() -> Promise<Int> {
        return Promise<Int> { [weak self] seal in
            self?.provider.request(.getTotalUsersCount) { result in
                switch result {
                    case .success(let response):
                        do {
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            let userData = try jsonDecoder.decode(UsersData.self, from: response.data)
                            seal.fulfill(userData.totalCount)
                        } catch {
                            print(error)
                            seal.reject(error)
                        }
                    case .failure(let error):
                        seal.reject(error)
                }
            }
        }
    }
}
