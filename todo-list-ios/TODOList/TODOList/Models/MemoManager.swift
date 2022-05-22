import Foundation
import OSLog

enum UserInfoKeys {
    static let memo = "Memo"
}

enum Task {
    case memoList
    case memoAdd
    case memoContentUpdate
    case memoStatusUpdate
    case memoDelete
    
    var path: String {
        switch self {
        case .memoList:
            return ""
        case .memoAdd:
            return "task"
        case .memoContentUpdate:
            return ""
        case .memoStatusUpdate:
            return ""
        case .memoDelete:
            return ""
        }
    }
}

class MemoManager {
    
    private var memoRepository: RepositoryApplicable?

    init(memoRepository: RepositoryApplicable) {
        self.memoRepository = memoRepository
        
        let memoList = fetchMemoList()
        
        for memo in memoList {
            switch memo.status {
            case .todo:
                memoTableViewModels[.todo]?.append(memo)
            case .progress:
                memoTableViewModels[.progress]?.append(memo)
            case .done:
                memoTableViewModels[.done]?.append(memo)
            }
        }
    }
    
    enum ObserverInfoKey: String {
        case memoDidAdd = "memoDidAdd"
    }
    
    private (set) var memoTableViewModels: [MemoStatus: [Memo]] = [.todo:[], .progress:[], .done:[]]
    
    func createMemo(memo: Memo, completion: (() -> ())? = nil) {
        memoRepository?.createMemo(memo: memo, completion: {
            self.appendMemoModels(containerType: memo.status, memos: [memo])
            NotificationCenter.default.post(name: .memoDidAdd, object: self, userInfo: [UserInfoKeys.memo: memo])
            completion?()
        })
    }
    
    func fetchMemoList() -> [Memo] {
        guard let todoEntityList = memoRepository?.fetchMemoList() else {
            return [Memo]()
        }
        
        var memoList = [Memo]()
        for todo in todoEntityList {
            let memoStatus: MemoStatus
            switch todo.status {
            case "해야 할 일":
                memoStatus = MemoStatus.todo
            case "하고있는 일":
                memoStatus = MemoStatus.progress
            default:
                memoStatus = MemoStatus.done
            }
            memoList.append(Memo(title: todo.title!, content: todo.content!, name: "Selina", status: memoStatus))
        }
        return memoList
    }
    
    func removeSelectedMemoModel(containerType: MemoStatus, index: Int) {
        memoTableViewModels[containerType]?.remove(at: index)
    }
    
    func insertSelectedMemoModel(containerType: MemoStatus, index: Int, memo: Memo) {
        memoTableViewModels[containerType]?.insert(memo, at: index)
    }
    
    func appendMemoModels(containerType: MemoStatus, memos:[Memo]) {
        memoTableViewModels[containerType]?.append(contentsOf: memos)
    }
    
    func getDesignatedMemosCount(containerType: MemoStatus)-> Int {
        return memoTableViewModels[containerType]?.count ?? 0
    }
    
    func getDesignatedMemoModel(containerType: MemoStatus, index: Int)-> Memo? {
        return memoTableViewModels[containerType]?[index] ?? nil
    }
    
    func convertStringToURL(url: String) -> URL? {
        guard let url = URL(string: url) else {
            return nil
        }
        return url
    }
    
    func sendModelDataToNetworkManager(memo: Memo, taskType: Task, methodType: HTTPMethod) {
        guard let url = convertStringToURL(url: EndPoint.url + taskType.path) else { return }

        memoRepository?.sendApiRequest(entity: memo.toRequestEntity(), url: url, methodType: methodType) { [weak self] data in
            guard let memoResponse = self?.memoRepository?.convertApiResponseToObject(data: data, targetType: MemoPostResponse.self) else { return }
            let memo = memoResponse.toResponseDto()
            self?.memoTableViewModels[.todo]?.insert(memo, at: 0)
            NotificationCenter.default.post(name: .memoDidAdd, object: self, userInfo: [UserInfoKeys.memo:memo])
        }
    }
}
