import Foundation

protocol RepositoryApplicable {
    func fetchData() -> [TodoEntity]
    func createMemo(memo: Memo, completion: (() -> ())?)
    func convertApiResponseToObject<T: Decodable>(data: Data, targetType: T.Type) -> T?
    func sendApiRequest<T: Encodable>(entity: T, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void)
}
