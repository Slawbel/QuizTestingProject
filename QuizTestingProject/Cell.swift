import UIKit
import SnapKit

class Cell: UICollectionViewCell {
    
    var answerNum = UIButton()
    var answerText = UILabel()
    var addActionClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        answerNum.contentHorizontalAlignment = .center
        answerNum.contentVerticalAlignment = .center
        answerNum.setTitleColor(.black, for: .normal)
        answerNum.layer.cornerRadius = 25
        answerNum.clipsToBounds = true
        answerNum.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        answerText.textAlignment = .center
        answerText.textColor = UIColor.white.withAlphaComponent(0.5)
        answerText.numberOfLines = 0
        answerText.font = UIFont.boldSystemFont(ofSize: 20)
        
        answerNum.addAction(UIAction { [weak self] _ in
            self?.addActionClosure?()
        }, for: .touchUpInside)
        
        contentView.addSubview(answerNum)
        contentView.addSubview(answerText)
        
        answerNum.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        answerText.snp.makeConstraints { make in
            make.trailing.equalTo(answerNum.snp.leading).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

