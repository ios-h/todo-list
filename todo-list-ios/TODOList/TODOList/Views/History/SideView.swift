import SnapKit
import UIKit

class SideView: UIView {
    
    weak var delegate: SideViewDelegate?
    
    private let emptyView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "close"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.delegate?.sideViewCloseButtonDidTap()
        }), for: .touchUpInside)
        return button
    }()
    
    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //현재 아래와 같이 구분선 설정을 없애도 사이드 뷰 내부의 테이블 뷰에 적용되지 않음
        tableView.separatorStyle = .none
        tableView.register(SideViewTableViewCell.self, forCellReuseIdentifier: SideViewTableViewCell.identifier)
        return tableView
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addViews()
        setConstraints()
    }
    
    private func addViews() {
        addSubview(emptyView)
        emptyView.addSubview(closeButton)
        addSubview(historyTableView)
    }
    
    private func setConstraints() {
        emptyView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(emptyView).offset(25)
            $0.trailing.equalTo(emptyView).offset(-50)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }

}
