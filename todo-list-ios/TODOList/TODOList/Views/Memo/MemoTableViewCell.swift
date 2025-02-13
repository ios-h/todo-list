import SnapKit
import UIKit

class MemoTableViewCell: UITableViewCell {

    static let identifier: String = "memoTableViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.bold, size: 16)
        label.textColor = .black
        label.text = "title"
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.normal, size: 14)
        label.textColor = .black
        label.text = "content"
        label.numberOfLines = 0
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFactory.normal, size: 12)
        label.textColor = .black
        label.text = "name"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addViews()
        setConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func addViews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(nameLabel)
        contentView.addSubview(stackView)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(16)
            $0.trailing.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    func updateStackView(memo: Memo) {
        titleLabel.text = memo.title
        contentLabel.text = memo.content
        nameLabel.text = memo.name
    }
    
    func updateStyle(){
        clipsToBounds = true
        layer.cornerRadius = 15
    }
}
