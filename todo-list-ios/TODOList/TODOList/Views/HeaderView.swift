import SnapKit
import UIKit

class HeaderView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.normal, size: 40)
        label.text = "TO-DO LIST"
        return label
    }()
    
    private lazy var sideMenuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.delegate?.headerViewButtonDidTap()
        }), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: HeaderViewDelegate?
    
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
        addSubview(titleLabel)
        addSubview(sideMenuButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(48)
        }

        sideMenuButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-50)
        }
    }
}
