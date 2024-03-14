import UIKit
import SnapKit

class Cell: UICollectionViewCell {
    
    let answerNum = UILabel()
    let answerText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        answerNum.textAlignment = .center
        answerNum.backgroundColor = .white
        answerNum.textColor = .black
        answerNum.layer.cornerRadius = 25
        answerNum.clipsToBounds = true
        
        answerText.textAlignment = .left
        answerText.backgroundColor = .clear
        answerText.textColor = .white
        
        contentView.addSubview(answerNum)
        contentView.addSubview(answerText)
        
        answerNum.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        answerText.snp.makeConstraints { make in
            make.leading.equalTo(answerNum.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

