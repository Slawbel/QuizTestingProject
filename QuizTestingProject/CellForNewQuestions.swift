import UIKit
import SnapKit



class CellForNewQuestions: UICollectionViewCell, UITextViewDelegate {
    
    let answerNum = UILabel()
    let answerTextView = UITextView()
    
    weak var delegate: CellTextDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        answerNum.textAlignment = .center
        answerNum.backgroundColor = .white
        answerNum.textColor = .black
        answerNum.layer.cornerRadius = 25
        answerNum.clipsToBounds = true
        
        answerTextView.keyboardAppearance = .dark
        answerTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        answerTextView.textAlignment = .center
        answerTextView.backgroundColor = .clear
        answerTextView.textColor = .white
        answerTextView.font = UIFont.systemFont(ofSize: 16)
        answerTextView.layer.cornerRadius = 5
        answerTextView.layer.borderWidth = 0
        answerTextView.delegate = self
        answerTextView.textColor = UIColor.lightGray
        
        contentView.addSubview(answerNum)
        contentView.addSubview(answerTextView)
        
        answerNum.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        answerTextView.snp.makeConstraints { make in
            make.leading.equalTo(answerNum.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "Enter option answer here" {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            self.delegate?.cellDidTapText(text)
        }
    }
}



