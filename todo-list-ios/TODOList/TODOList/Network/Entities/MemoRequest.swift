import Foundation

struct MemoPostRequest: Encodable {
    private let title: String
    private let content: String
    private let author: String
    private let status: String
    
    init(title: String, content: String, author: String, status: String) {
        self.title = title
        self.content = content
        self.author = author
        self.status = status
    }
}
