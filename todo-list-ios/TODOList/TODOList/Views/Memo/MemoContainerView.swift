import SnapKit
import UIKit

class MemoContainerView: UIView {
    
    weak var delegate: MemoContainerViewDelegate?
    
    var containerType: MemoStatus?

    private let containerTitleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.bold, size: 20)
        label.textColor = UIColor(named: ColorAsset.black)
        label.textAlignment = .left
        return label
    }()
    
    private let countView: UIView = {
        let label = UIView()
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.bold, size: 14)
        label.textColor = UIColor(named: ColorAsset.black)
        label.backgroundColor = UIColor(named: ColorAsset.gray4)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "add"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.delegate?.addButtonDidTap(containerType: self.containerType!)
        }), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        tableView.separatorStyle = .none
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
        tableView.backgroundColor = .clear
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
        
        countView.addSubview(countLabel)
        containerTitleView.addSubview(categoryLabel)
        containerTitleView.addSubview(countView)
        containerTitleView.addSubview(addButton)
        
        addSubview(containerTitleView)
        addSubview(tableView)
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.leading.centerY.equalTo(containerTitleView)
        }
        
        countLabel.snp.makeConstraints {
            $0.width.height.centerX.centerY.equalTo(countView)
        }
        
        countView.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(containerTitleView)
            $0.width.equalTo(30)
            $0.height.equalTo(countView.snp.width)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalTo(containerTitleView)
            $0.centerY.equalTo(containerTitleView)
        }
        
        containerTitleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(containerTitleView.snp.bottom)
            $0.leading.trailing.equalTo(containerTitleView)
            $0.bottom.equalToSuperview()
        }
    }
}
