import Foundation

// MemoRepositor는 말 그대로 구현체
// MemoManager는 추상타립 RepositoryApplicable (MemoReposiroty 포함한)를 채택한 모든 구현체를 바라볼 수 있음. 
struct MemoRepository: RepositoryApplicable {
    // 의존성 주입받을 때, 속성을 추상 타입으로 하도록 하는거..
    private var coreDataManager: CoreDataManager
    private var networkHandler: NetworkHandler
    private (set) var jsonHandler: JSONHandler
    
    init(coreDataManager: CoreDataManager, networkHandler: NetworkHandler, jsonHandler: JSONHandler) {
        self.coreDataManager = coreDataManager
        self.networkHandler = networkHandler
        self.jsonHandler = jsonHandler
    }
    
    func fetchData() -> [TodoEntity] {
        let entities = coreDataManager.fetch()
        return entities
    }
    
    func createMemo(memo: Memo, completion: (() -> ())?) {
        coreDataManager.create(title: memo.title, content: memo.content, status: memo.status.description) {
            completion?()
        }
    }
    
    func sendApiRequest<T: Encodable>(entity: T, url: URL, methodType: HTTPMethod, successHandler: @escaping (Data)->Void) {
        guard let data = jsonHandler.convertObjectToJSON(model: entity) else { return }
        networkHandler.mockRequest(data: data, url: url, methodType: methodType, successHandler: successHandler)
    }
    
    func convertApiResponseToObject<T: Decodable>(data: Data, targetType: T.Type) -> T? {
        return self.jsonHandler.convertJSONToObject(data: data, targetType: targetType)
    }
    
}

