import Foundation

final class JSONHandler {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func convertObjectToJSON<T: Encodable>(model: T) -> Data? {
        return try? encoder.encode(model)
    }
    
    func convertJSONToObject<T: Decodable>(data: Data, targetType: T.Type) -> T? {
        return try? decoder.decode(T.self, from: data)
    }
    
}
