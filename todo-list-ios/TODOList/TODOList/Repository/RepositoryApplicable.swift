import Foundation

protocol RepositoryApplicable {
    func sendApiRequest(data: Data, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void)
}
