import UIKit
import CoreData
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
    
    var question: String = ""
    var answers: [String] = []
    var correctAnswerNum: [UInt16] = []
    
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
            self.createData()
            print("Saved questionL \(self.question)")
            print("Saved answers: \(self.answers)")
            print("Correct answers: \(self.correctAnswerNum)")
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
        cell.answerNum.setTitle("\(indexPath.row + 1).", for: .normal)
        cell.answerTextView.text = "Enter option answer here"
        
        cell.answerNum.addAction(UIAction { _ in
            cell.answerNum.backgroundColor = .green
            self.correctAnswerNum.append(UInt16(indexPath.row + 1))
        }, for: .touchUpInside)

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
}

extension NewQuestionsScreen {
    func createData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to retrieve app delegate")
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Create a new QuizQuestion object
        guard let entity = NSEntityDescription.entity(forEntityName: "QuizQuestion", in: managedContext) else {
            print("Failed to retrieve entity description")
            return
        }

        let quizQuestion = NSManagedObject(entity: entity, insertInto: managedContext)

        guard !self.question.isEmpty else {
            print("Question is empty. Data not saved.")
            return
        }

        // For each answer string, create an Answer object and associate it with the QuizQuestion
        for answerString in self.answers {
            let answerEntity = NSEntityDescription.entity(forEntityName: "Answer", in: managedContext)!
            let answerObject = NSManagedObject(entity: answerEntity, insertInto: managedContext)
            answerObject.setValue(answerString, forKey: "singleAnswer")
            
            // Add the Answer object to the QuizQuestion's relationship
            quizQuestion.mutableSetValue(forKey: "connectionWithSingleAnswer").add(answerObject)
        }

        // Save the changes
        do {
            try managedContext.save()
            print("Data saved successfully")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }

}



