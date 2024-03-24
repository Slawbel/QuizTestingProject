import UIKit
import SnapKit

class CellForDeleteQuestions: UITableViewCell {
    var questionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.backgroundColor = .clear
        questionLabel.alpha = 0.3
        questionLabel.textColor = .white
        questionLabel.clipsToBounds = true
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        contentView.addSubview(questionLabel)
        
        questionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
