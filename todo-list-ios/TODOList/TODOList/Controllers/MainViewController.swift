import CoreData
import SnapKit
import UIKit

final class MainViewController: UIViewController {
    
    var memoList = [TodoEntity]() // 모든 메모 데이터를 저장할 배열
    
    convenience init(coreDataManager: CoreDataManager) {
        self.init()
        
        memoCanvasViewController = createMemoCanvasViewController(coreDataManager: coreDataManager)
        
        memoList = coreDataManager.fetch()
        print(memoList)
    }
    
    private var headerView: HeaderView = {
        let view = HeaderView()
        return view
    }()
    
    private var sideView: SideView = {
        let view = SideView()
        view.backgroundColor = .white
        return view
    }()
    
    private var memoCanvasViewController: MemoCanvasViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: ColorAsset.gray6)
        
        guard let memoCanvasViewController = memoCanvasViewController else {
            return
        }
        
        addChild(memoCanvasViewController)
        view.addSubview(memoCanvasViewController.view)
        memoCanvasViewController.didMove(toParent: self)
        self.memoCanvasViewController = memoCanvasViewController
        
        self.headerView.delegate = self
        
        self.sideView.delegate = self
        self.sideView.historyTableView.dataSource = self
        self.sideView.historyTableView.delegate = self
        
        addViews()
        setLayout()
    }
    
    private func createMemoCanvasViewController(coreDataManager: CoreDataManager) -> MemoCanvasViewController {
        let memoRepository: RepositoryApplicable = MemoRepository(coreDataManager: coreDataManager, networkHandler: NetworkHandler(), jsonHandler: JSONHandler())
        let memoManager = MemoManager(memoRepository: memoRepository)
        return MemoCanvasViewController(memoManager: memoManager)
    }
    
    override func viewDidLayoutSubviews() {
        // 처음 화면 실행 시 Sideview 숨기기
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
            self.sideView.transform = CGAffineTransform(translationX: self.sideView.frame.width, y: 0)
        }
    }
    
    /// 초기 뷰 설정. 초기 뷰는 sideMenuButton이 보여지는 상태.
    private func addViews() {
        view.addSubview(headerView)
        view.addSubview(sideView)
    }
    
    private func setLayout(){
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.height.equalToSuperview().multipliedBy(0.08)
        }
        
        memoCanvasViewController?.view.snp.makeConstraints({
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.leading.equalTo(headerView.snp.leading)
            $0.trailing.equalTo(headerView.snp.trailing)
            $0.bottom.equalToSuperview().offset(-25)
        })
        
        sideView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    /// sideMenuButton 클릭 시 SideView를 보여준다.
    private func showSideView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.sideView.transform = .identity // sideView 위치를 defaultValue로 돌려줌.
        }
    }
    
    /// SideMenu에 있는 닫기 버튼 클릭 시, sideView를 제거하고 SideMenuButton을 보여줌.
    private func hideSideView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.sideView.transform = CGAffineTransform(translationX: self.sideView.frame.width, y: 0)
        }
    }
}

extension MainViewController: HeaderViewDelegate{
    func headerViewButtonDidTap() {
        showSideView()
    }
}


extension MainViewController: SideViewDelegate {
    func sideViewCloseButtonDidTap() {
        hideSideView()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //직접 테이블 뷰의 셀을 로드하는 시점에 구분선 설정을 해야 적용되고 있음
        tableView.separatorStyle = .none
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideViewTableViewCell.identifier, for: indexPath) as? SideViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.emojiView.image = UIImage(named: "emoji")
        
        let history = HistoryInfo(name: "Selina", content: "이제 자러갑니당", time: "0")
        cell.updateStackView(history: history)
        return cell
    }
}
