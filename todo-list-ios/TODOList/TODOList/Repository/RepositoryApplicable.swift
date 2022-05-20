import Foundation

protocol RepositoryApplicable {
    func createMemo(memo: Memo, completion: (() -> ())?)
    func fetchMemoList() -> [TodoEntity]
    func convertApiResponseToObject<T: Decodable>(data: Data, targetType: T.Type) -> T?
    func sendApiRequest<T: Encodable>(entity: T, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void)
}
