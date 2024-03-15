import UIKit
import SnapKit

class NewQuestionsScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    private let counterLabel = UILabel()
    private let questionLabel = UILabel()
    private let newQuestionTextView = UITextView()
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexQuizScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexQuizScreen)
        
        counterLabel.alpha = 0.3
        counterLabel.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        counterLabel.textColor = .white
        counterLabel.layer.cornerRadius = 30
        counterLabel.clipsToBounds = true
        
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.textColor = .white
        questionLabel.backgroundColor = .black
        questionLabel.alpha = 0.3
        questionLabel.layer.cornerRadius = 50
        questionLabel.clipsToBounds = true
        
        newQuestionTextView.keyboardAppearance = .dark
        newQuestionTextView.textAlignment = .center
        newQuestionTextView.backgroundColor = .clear
        newQuestionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        newQuestionTextView.font = UIFont.systemFont(ofSize: 16)
        newQuestionTextView.layer.cornerRadius = 10
        newQuestionTextView.layer.borderWidth = 0
        newQuestionTextView.delegate = self
        newQuestionTextView.text = "Enter your question here"
        newQuestionTextView.textColor = UIColor.lightGray
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 70)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        collectionView.register(CellForNewQuestions.self, forCellWithReuseIdentifier: "CellForNewQuestions")
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(counterLabel)
        view.addSubview(questionLabel)
        view.addSubview(newQuestionTextView)
        view.addSubview(collectionView)
        
        
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.width.height.equalTo(60)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(180)
            make.height.equalTo(250)
            make.width.equalTo(340)
        }
        
        newQuestionTextView.snp.makeConstraints { make in
            make.centerX.equalTo(questionLabel)
            make.top.equalTo(questionLabel.snp.top).offset(10)
            make.width.equalTo(320) // Adjust width as needed
            make.height.equalTo(230) // Adjust height as needed
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(450)
            make.width.height.equalTo(350)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForNewQuestions", for: indexPath) as! CellForNewQuestions
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cell.layer.cornerRadius = 35
        
        cell.answerNum.text = "\(indexPath.row + 1)."
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350 // Adjust the divisor and subtracted value as needed
        let height: CGFloat = 70 // Keep the height constant
        return CGSize(width: width, height: height)
    }
}

extension NewQuestionsScreen {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "Enter your question here" {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            collectionView.contentInset = contentInsets
            collectionView.scrollIndicatorInsets = contentInsets
        }
    }
        
    @objc private func keyboardWillHide(_ notification: Notification) {
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
}
