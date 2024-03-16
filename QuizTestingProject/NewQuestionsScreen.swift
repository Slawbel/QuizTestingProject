import UIKit
import SnapKit

protocol CellTextDelegate: AnyObject {
    func cellDidTapText(_ text: String)
}

class NewQuestionsScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, CellTextDelegate {
    private let counterLabel = UILabel()
    private let questionLabel = UILabel()
    private let newQuestionTextView = UITextView()
    private var collectionView: UICollectionView!
    private let backButton = UIButton()
    private let saveButton = UIButton()
    
    var newQuestion: Quiz?
    
    var question: String = ""
    var answers: [String] = []
    var correctAnswerNum: UInt8 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexQuizScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexQuizScreen)
        
        backButton.alpha = 0.3
        backButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        backButton.layer.cornerRadius = 20
        backButton.setTitle("Exit", for: .normal)
        backButton.addAction(UIAction { _ in
            Coordinator.closeAnotherScreen(from: self)
        }, for: .touchUpInside)
        
        saveButton.alpha = 0.3
        saveButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("Save", for: .normal)
        saveButton.addAction(UIAction {_ in 
            self.answers.removeAll()
            self.question.removeAll()
            for cell in self.collectionView.visibleCells {
                if let cellForQuestion = cell as? CellForNewQuestions, let text = cellForQuestion.answerTextView.text {
                    if !text.isEmpty {
                        self.answers.append(text)
                    }
                }
            }
            self.question = self.newQuestionTextView.text
            print("Saved questionL \(self.question)")
            print("Saved answers: \(self.answers)")
        }, for: .touchUpInside)
        
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
        newQuestionTextView.text = "Enter your question here"
        newQuestionTextView.textColor = UIColor.lightGray
        newQuestionTextView.delegate = self

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
        
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(counterLabel)
        view.addSubview(questionLabel)
        view.addSubview(newQuestionTextView)
        view.addSubview(collectionView)
        
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(60)
            make.leading.equalTo(view).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(60)
            make.trailing.equalTo(view).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(130)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(210)
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
            make.top.equalTo(view).inset(480)
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
        cell.answerTextView.text = "Enter option answer here"
        //cell.answerTextView.delegate = cell
        cell.delegate = self
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350 // Adjust the divisor and subtracted value as needed
        let height: CGFloat = 70 // Keep the height constant
        return CGSize(width: width, height: height)
    }
    
    @objc private func saveTapped() {
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func cellDidTapText(_ text: String) {
        self.answers.append(text)
    }
    
    /*func saveNewQuestion() {
        newQuestion = Quiz(question: <#T##String#>, answers: <#T##[String]#>, correctAnswerNum: <#T##UInt8#>)
    }*/
}

