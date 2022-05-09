import UIKit

class SideViewTableViewCell: UITableViewCell {
    
    static let identifier: String = "sideViewTableViewCell"
    
    let emojiView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let historyView: UIView = {
        let view = UIView()
        return view
    }()
    
    var historyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontFactory.normal, size: 16)
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontFactory.bold, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontFactory.normal, size: 14)
        label.textColor = UIColor(named: ColorAsset.gray3)
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
        contentView.addSubview(emojiView)
        historyView.addSubview(historyStackView)
        historyStackView.addArrangedSubview(nameLabel)
        historyStackView.addArrangedSubview(contentLabel)
        historyStackView.addArrangedSubview(timeLabel)
        contentView.addSubview(historyView)
    }
    
    private func setConstraints() {
        historyStackView.snp.makeConstraints {
            $0.edges.equalTo(historyView)
        }
        
        emojiView.snp.makeConstraints {
            $0.leading.top.equalTo(contentView).offset(16)
            $0.width.height.equalTo(40)
        }
        
        historyView.snp.makeConstraints {
            $0.leading.equalTo(emojiView.snp.trailing).offset(16)
            $0.top.equalTo(emojiView.snp.top)
            $0.trailing.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    func updateStackView(history: HistoryInfo) {
        nameLabel.text = "@\(history.name)"
        contentLabel.text = history.content
        timeLabel.text = "\(history.time)분 전"
    }
}
