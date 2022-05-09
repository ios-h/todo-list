import SnapKit
import UIKit

final class MemoCanvasViewController: UIViewController {
    
    private var memoCanvasView: MemoCanvasView = {
        let view = MemoCanvasView()
        return view
    }()
    
    private (set) var memoTableViewControllers: [MemoStatus: MemoContainerViewController] = [:]
    private (set) var memoManager: MemoManager = MemoManager()
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view = memoCanvasView
        
        initProperties()
        setLayout()
        subscribeObserver()
    }
    
    private func initProperties() {
        for containerType in MemoStatus.allCases {
            addTableViewController(containerType: containerType)
        }
    }
    
    private func addTableViewController(containerType: MemoStatus) {
        let tableViewController = MemoContainerViewController(containerType: containerType)
        memoTableViewControllers[containerType] = tableViewController
        
        addChild(tableViewController)
        memoCanvasView.memoContainerStackView.addArrangedSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)
        
        addTableViewConfigurations(tableViewController: tableViewController)
    }
    
    private func addTableViewConfigurations(tableViewController: MemoContainerViewController) {
        tableViewController.memoContainerView.tableView.dataSource = tableViewController
        tableViewController.memoContainerView.tableView.delegate = tableViewController
        tableViewController.memoContainerView.tableView.dragDelegate = tableViewController
        tableViewController.memoContainerView.tableView.dropDelegate = tableViewController
        tableViewController.memoContainerView.tableView.dragInteractionEnabled = true
        tableViewController.memoContainerView.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
    }
    
    private func setLayout() {
        memoCanvasView.addSubview(memoCanvasView.memoContainerStackView)
        
        memoCanvasView.memoContainerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(48)
            $0.top.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.75)
        }
        
        for ( _ , tableViewController ) in memoTableViewControllers {
            tableViewController.memoContainerView.snp.makeConstraints {
                $0.top.equalTo(memoCanvasView.memoContainerStackView.snp.top)
                $0.bottom.equalTo(memoCanvasView.memoContainerStackView.snp.bottom)
            }
        }
    }
    
    func removeSelectedMemoModel(containerType: MemoStatus, indexPath: IndexPath) {
        memoManager.removeSelectedMemoModel(containerType: containerType, index: indexPath.section)
    }
    
    func insertSelectedMemoModel(containerType: MemoStatus, indexPath: IndexPath, memoModel: Memo) {
        memoManager.insertSelectedMemoModel(containerType: containerType, index: indexPath.section, memo: memoModel)
    }
    
    private func subscribeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didMemoAdd(_:)),
                                               name: .memoDidAdd,
                                               object: memoManager)
    }
    
    @objc func didMemoAdd(_ notification: Notification) {
        if let memo = notification.userInfo?[UserInfoKeys.memo] as? Memo {
            updateView(containerType: memo.status)
        }
    }
    
    private func updateView(containerType: MemoStatus) {
        memoTableViewControllers[containerType]?.memoContainerView.tableView.reloadData()
        
        guard let currentMemoCount = memoTableViewControllers[containerType]?.memoContainerView.tableView.numberOfSections else {
            return
        }
        memoTableViewControllers[containerType]?.memoContainerView.countLabel.text = "\(currentMemoCount)"
    }
}

