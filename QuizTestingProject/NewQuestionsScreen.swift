import UIKit
import RealmSwift
import SnapKit

protocol CellTextDelegate: AnyObject {
    func cellDidTapText(_ text: String)
}

class NewQuestionsScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, CellTextDelegate {
    private let questionLabel = UILabel()
    private let newQuestionTextView = UITextView()
    private var collectionView: UICollectionView!
    private let backButton = UIButton()
    private let saveButton = UIButton()
        
    var question: String = ""
    var answers: [String] = []
    var selectedAnswers: [Int8] = []
    
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
        saveButton.addAction(UIAction { _ in
            self.saveData()
        }, for: .touchUpInside)
        
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
        newQuestionTextView.font = UIFont.systemFont(ofSize: 25)
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
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(130)
            make.height.equalTo(330)
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
        
        // colours for answerNum button background
        let emeraldColour = SetColorByCode.hexStringToUIColor(hex: "#556B2F")
        let maroonRedColour = SetColorByCode.hexStringToUIColor(hex: "#800000")
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cell.layer.cornerRadius = 35
        cell.answerNum.setTitle("\(indexPath.row + 1).", for: .normal)
        cell.answerNum.backgroundColor = maroonRedColour
        cell.answerTextView.text = "Enter option answer here"
        
        cell.answerNum.addAction(UIAction { _ in
            if let index = self.selectedAnswers.firstIndex(of: Int8(indexPath.row + 1)) {
                self.selectedAnswers.remove(at: index)
                cell.answerNum.backgroundColor = maroonRedColour
            } else {
                self.selectedAnswers.append(Int8(indexPath.row + 1))
                cell.answerNum.backgroundColor = emeraldColour
            }
        }, for: .touchUpInside)

        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350
        let height: CGFloat = 70
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func cellDidTapText(_ text: String) {
        self.answers.append(text)
    }
}

extension NewQuestionsScreen {
    func saveData() {
        self.answers = []
        if let questionText = newQuestionTextView.text, !questionText.isEmpty {
            self.question = questionText
            
            for cell in collectionView.visibleCells {
                if let cellForQuestion = cell as? CellForNewQuestions, let answer = cellForQuestion.answerTextView.text {
                    self.answers.append(answer)
                }
            }
            
            if self.checkOfEmptyElements() {
                print("checkpoint1")
                showAlert()
                return
            }

            let quizModel = QuizModel()
            quizModel.question = self.question

            if let firstAnswer = self.answers.first {
                quizModel.answer1 = firstAnswer
            }
            if self.answers.count > 1 {
                quizModel.answer2 = self.answers[1]
            }
            if self.answers.count > 2 {
                quizModel.answer3 = self.answers[2]
            }
            if self.answers.count > 3 {
                quizModel.answer4 = self.answers[3]
            }
            
            if !selectedAnswers.isEmpty {
                for (index, element) in selectedAnswers.enumerated() {
                    switch index {
                    case 0:
                        quizModel.corAnswer1 = element
                    case 1:
                        quizModel.CorAnswer2 = element
                    case 2:
                        quizModel.CorAnswer3 = element
                    default:
                        break
                    }
                }
            }
            print(quizModel)

            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(quizModel)
                    print("Quiz model added to Realm")
                    Coordinator.closeAnotherScreen(from: self)
                }
            } catch {
                print("Error saving quizModel: \(error)")
            }
        }
    }
    
    private func checkOfEmptyElements() -> Bool {
        print(question)
        print(answers)
        print(selectedAnswers)
        return question.isEmpty || answers.count < 4 || answers.contains("") || answers.contains("Enter option answer here") || selectedAnswers.isEmpty
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Incomplete Information", message: "Please, fill in all fields to save the data", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("User tapped OK")
        }
        alertController.addAction(exitAction)
        present(alertController, animated: true, completion: nil)
    }
}
