import Foundation

struct MemoRepository: RepositoryApplicable {
    
    private var networkHandler: NetworkHandler
    private var jsonHandler: JSONHandler
    
    init(networkHandler: NetworkHandler, jsonHandler: JSONHandler) {
        self.networkHandler = networkHandler
        self.jsonHandler = jsonHandler
    }
    
    func sendApiRequest(data: Data, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void) {
    
        networkHandler.mockRequest(data: data, url: url, methodType: methodType, successHandler: successHandler)
    }
    
}

