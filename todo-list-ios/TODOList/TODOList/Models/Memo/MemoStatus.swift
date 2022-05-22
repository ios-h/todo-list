import Foundation

enum MemoStatus: String, CaseIterable, Codable {
    case todo = "해야 할 일"
    case progress = "하고있는 일"
    case done = "완료한 일"
}
