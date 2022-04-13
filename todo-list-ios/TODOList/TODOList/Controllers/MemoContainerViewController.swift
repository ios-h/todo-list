import UIKit

class MemoContainerViewController: UIViewController {

    private var containerType: MemoContainerType?
    private var selectedIndexPath: IndexPath?
    
    private (set) var memoContainerView: MemoContainerView = {
        let containerView = MemoContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    convenience init(containerType: MemoContainerType){
        self.init()
        self.containerType = containerType
        memoContainerView.categoryLabel.text = " \(containerType)"
        view = memoContainerView
    }
}

extension MemoContainerViewController: UITableViewDataSource & UITableViewDelegate {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        guard let parentViewController = parent as? MemoCanvasViewController,
//              let containerType = containerType,
//              let memos = parentViewController.memoTableViewModels[containerType] else { return 0 }
//        return memos.count
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parentViewController = parent as? MemoCanvasViewController,
              let containerType = containerType,
              let memos = parentViewController.memoTableViewModels[containerType] else { return 0 }
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell,
              let parentViewController = parent as? MemoCanvasViewController,
              let containerType = containerType,
              let memos = parentViewController.memoTableViewModels[containerType] else { return UITableViewCell() }
        
        cell.updateStackView(memo: memos[indexPath.row])
        cell.updateStyle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupViewController = PopupViewController()
        popupViewController.modalPresentationStyle = .overCurrentContext
        
        switch indexPath.section {
        case 0:
            self.present(popupViewController, animated: true)
        default:
            self.present(popupViewController, animated: true)
        }
    }
}

extension MemoContainerViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let parentViewController = parent as? MemoCanvasViewController,
              let containerType = containerType,
              let memos = parentViewController.memoTableViewModels[containerType] else { return [] }
        
        let memo = memos[indexPath.row]
        let itemProvider = NSItemProvider(object: memo)
        selectedIndexPath = indexPath
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        guard let parentViewController = parent as? MemoCanvasViewController,
              let containerType = containerType,
              let selectedIndexPath = selectedIndexPath else { return }

        parentViewController.removeSelectedMemoModel(containerType: containerType, indexPath: selectedIndexPath)
        tableView.beginUpdates()
        tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
//        tableView.deleteSections([selectedIndexPath.section], with: .automatic)
        tableView.endUpdates()
    
        self.selectedIndexPath = nil
    }
}

extension MemoContainerViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: Memo.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard session.items.count == 1 else { return UITableViewDropProposal(operation: .cancel) }
        
        
        if tableView.hasActiveDrag && tableView.isEditing {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }else {
            if let indexPath = selectedIndexPath {
                selectedIndexPath = indexPath
            }
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let parentViewController = parent as? MemoCanvasViewController,
              let containerType = containerType else { return }
        
        var destinationPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        if let indexPath = coordinator.destinationIndexPath {
            destinationPath = indexPath
        }
        
        coordinator.session.loadObjects(ofClass: Memo.self) { items in
            guard let items = items as? [Memo] else { return }
//            var indexPaths:IndexSet = IndexSet()
            var indexPaths:[IndexPath] = []
            
            for ( index , value ) in items.enumerated() {
                let indexPath = IndexPath(row: destinationPath.row + index, section: destinationPath.section)
                parentViewController.insertSelectedMemoModel(containerType: containerType, indexPath: indexPath, memoModel: value)
                indexPaths.append(indexPath)
//                indexPaths.insert(indexPath.section)
            }
            
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths, with: .automatic)
//            tableView.insertSections(indexPaths, with: .automatic)
            tableView.endUpdates()
        }
    }

}
