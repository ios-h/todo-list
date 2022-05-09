import SnapKit
import UIKit

class PopupCardView: UIView {

    weak var delegate: PopupCardViewDelegate?
    var memoContainerType: MemoStatus?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.bold, size: 16)
        return label
    }()
    
    let titleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요"
        textField.font = UIFont(name: FontFactory.bold, size: 14)
        textField.textColor = UIColor(named: ColorAsset.gray3)
        textField.becomeFirstResponder()
        return textField
    }()
    
    let contentField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "내용을 입력하세요"
        textField.font = UIFont(name: FontFactory.normal, size: 14)
        textField.textColor = UIColor(named: ColorAsset.gray3)
        return textField
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(named: ColorAsset.gray5)
        button.setTitleColor(UIColor(named: ColorAsset.gray3), for: .normal)
        button.titleLabel?.font = UIFont(name: FontFactory.normal, size: 14)
        button.layer.cornerRadius = 6
        button.addAction(UIAction(handler: { _ in
            self.delegate?.popupCardCancelButtonDidTap()
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록", for: .normal)
        button.backgroundColor = UIColor(named: ColorAsset.blue)
        button.setTitleColor(UIColor(named: ColorAsset.white), for: .normal)
        button.titleLabel?.font = UIFont(name: FontFactory.normal, size: 14)
        button.layer.cornerRadius = 6
        button.addAction(UIAction(handler: { _ in
            self.delegate?.popupCardOkButtonDidTap(title: self.titleField.text, content: self.contentField.text, status: self.memoContainerType)
        }), for: .touchUpInside)
        return button
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
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
        containerView.addSubview(alertLabel)
        
        verticalStackView.addArrangedSubview(titleField)
        verticalStackView.addArrangedSubview(contentField)
        containerView.addSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(cancelButton)
        horizontalStackView.addArrangedSubview(okButton)
        containerView.addSubview(horizontalStackView)
        
        addSubview(containerView)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(400)
            $0.height.equalTo(160)
        }
        
        alertLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(containerView)
            $0.height.equalTo(20)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(alertLabel)
            $0.top.equalTo(alertLabel.snp.bottom).offset(16)
            $0.height.equalTo(60)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.trailing.equalTo(alertLabel)
            $0.top.equalTo(verticalStackView.snp.bottom).offset(16)
            $0.bottom.equalTo(containerView.snp.bottom)
            $0.width.equalTo(220)
        }
    }
}
