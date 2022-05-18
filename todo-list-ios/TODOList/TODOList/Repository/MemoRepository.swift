import Foundation

struct MemoRepository: RepositoryApplicable {
    
    private var networkHandler: NetworkHandler
    private (set) var jsonHandler: JSONHandler
    
    init(networkHandler: NetworkHandler, jsonHandler: JSONHandler) {
        self.networkHandler = networkHandler
        self.jsonHandler = jsonHandler
    }
    
    func sendApiRequest<T: Encodable>(entity: T, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void) {
        guard let data = jsonHandler.convertObjectToJSON(model: entity) else { return }
        networkHandler.mockRequest(data: data, url: url, methodType: methodType, successHandler: successHandler)
    }
    
    func convertApiResponseToObject<T: Decodable>(data: Data, targetType: T.Type) -> T? {
        return self.jsonHandler.convertJSONToObject(data: data, targetType: targetType)
    }
    
}

