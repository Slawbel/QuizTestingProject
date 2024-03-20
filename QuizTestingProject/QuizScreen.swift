import UIKit
import SnapKit
import RealmSwift

class QuizScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let counterLabel = UILabel()
    private let questionLabel = PaddingLabel()
    private var collectionView: UICollectionView!
    private let backButton = UIButton()
    private let finishButton = UIButton()
    
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    
    private var question: [String] = []
    private var answers: [[String]] = []
    private var correctAnswer: [[Int16]] = []
    
    var currentQuestionCounter = 0
    var selectedAnswers: [[Int16]] = []
    var correctAnswersAferCheck: Int = 0
    var sourceSelector: Bool
    
    init(decision: Bool) {
        self.sourceSelector = decision
        super.init(nibName: nil, bundle: nil)
        returnData()
        selectedAnswers = Array(repeating: [], count: question.count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if sourceSelector == true{
            returnData()
            print("success2")
        } else {
            
        }*/
        
        let colorsHexQuizScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexQuizScreen)
        
        backButton.alpha = 0.3
        backButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        backButton.layer.cornerRadius = 20
        backButton.setTitle("Exit", for: .normal)
        backButton.addAction(UIAction { _ in
            self.exitAction()
        }, for: .touchUpInside)
        
        finishButton.alpha = 0.3
        finishButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        finishButton.layer.cornerRadius = 20
        finishButton.setTitle("Finish", for: .normal)
        finishButton.addAction(UIAction {_ in
            self.checkAnswer(selectedAnswer: self.selectedAnswers, correctAnswer: self.correctAnswer)
            self.showAlert()
            print(self.selectedAnswers)
        }, for: .touchUpInside)
        
        counterLabel.alpha = 0.3
        counterLabel.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        counterLabel.textColor = .white
        counterLabel.layer.cornerRadius = 30
        counterLabel.clipsToBounds = true
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        previousButton.alpha = 0.3
        previousButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        previousButton.layer.cornerRadius = 30
        previousButton.setTitle("<", for: .normal)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        hidePreviousButton()

        nextButton.alpha = 0.3
        nextButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        nextButton.layer.cornerRadius = 30
        nextButton.setTitle(">", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.backgroundColor = .black
        questionLabel.alpha = 0.3
        questionLabel.textColor = .white
        questionLabel.layer.cornerRadius = 50
        questionLabel.clipsToBounds = true
        questionLabel.edgeInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)

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
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        
        
        
        setDataToScreen()
        
        view.addSubview(backButton)
        view.addSubview(finishButton)
        view.addSubview(counterLabel)
        view.addSubview(questionLabel)
        view.addSubview(collectionView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(60)
            make.leading.equalTo(view).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(60)
            make.trailing.equalTo(view).inset(20)
            make.width.equalTo(80)
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
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(480)
            make.width.height.equalTo(350)
        }
        
        previousButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(130)
            make.leading.equalTo(view).inset(60)
            make.height.width.equalTo(60)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(130)
            make.trailing.equalTo(view).inset(60)
            make.height.width.equalTo(60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cell.layer.cornerRadius = 35
        
        cell.answerNum.setTitle("\(indexPath.row + 1).", for: .normal)
        
        // Check if the current question index is within bounds
        if self.currentQuestionCounter < self.answers.count {
            let currentAnswers = self.answers[self.currentQuestionCounter]
            
            // Check if the row index is within bounds for the current question's answers
            if indexPath.row < currentAnswers.count {
                cell.answerText.text = currentAnswers[indexPath.row]
            } else {
                // Handle the case where indexPath.row is out of bounds
            }
        } else {
            // Handle the case where self.currentQuestionCounter is out of bounds
        }
        
        cell.answerNum.backgroundColor = .white
        
        // Checking if selected answers exist for the current question and updating the background color
        if !selectedAnswers.isEmpty && currentQuestionCounter < selectedAnswers.count {
            let selectedIndices = selectedAnswers[currentQuestionCounter]
            if selectedIndices.contains(Int16(indexPath.row + 1)) {
                cell.answerNum.backgroundColor = .gray
            }
        }
        
        cell.addActionClosure = { [weak self] in
            guard let self = self else { return }
            self.addSelectedAnswers(Int16(indexPath.row+1))
            cell.answerNum.backgroundColor = .gray
        }
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350
        let height: CGFloat = 70
        return CGSize(width: width, height: height)
    }
    
    func returnData() {
        do {
            let realm = try Realm()
            let quizQuestions = realm.objects(QuizModel.self)
            print(quizQuestions)
            
            for _ in quizQuestions {
                // Append an empty array for each question
                selectedAnswers.append([])
            }
            
            for questionObject in quizQuestions {
                question.append(questionObject.question)
                
                var answerArray: [String] = []
                for answerObject in questionObject.options {
                    answerArray.append(answerObject.text)
                }
                answers.append(answerArray)
                
                var correctAnswerArray: [Int16] = []
                for correctAnswerObject in questionObject.correctAnswers {
                    correctAnswerArray.append(correctAnswerObject)
                }
                correctAnswer.append(correctAnswerArray)
            }
            
            // Print the retrieved data
            print("Question: \(question)")
            print("Answers: \(answers)")
            print("Correct Answers: \(correctAnswer)")
        } catch {
            print("Error retrieving data from Realm: \(error)")
        }
    }



    
    func setDataToScreen() {
        questionLabel.text = question[currentQuestionCounter]
        counterLabel.text = "\(currentQuestionCounter+1) from \(question.count)"
    }
    
    @objc func previousButtonTapped() {
        if currentQuestionCounter > 0 {
            self.currentQuestionCounter-=1
            if currentQuestionCounter != question.count-1 {
                nextButton.isHidden = false
            }
        }
        self.hidePreviousButton()
        setDataToScreen()
        collectionView.reloadData()
    }
    
    @objc func nextButtonTapped() {
        if currentQuestionCounter < question.count-1 {
            self.currentQuestionCounter+=1
            if currentQuestionCounter != 0 {
                previousButton.isHidden = false
            }
        }
        if currentQuestionCounter == question.count-1 {
            nextButton.isHidden = true
        }
        setDataToScreen()
        collectionView.reloadData()
        
    }
    
    func addSelectedAnswers(_ numOfSelectedAnswer: Int16) {
        if selectedAnswers[currentQuestionCounter].contains(numOfSelectedAnswer) { return }
        selectedAnswers[currentQuestionCounter].append(numOfSelectedAnswer)
    }
    
    func hidePreviousButton() {
        if currentQuestionCounter == 0 {
            previousButton.isHidden = true
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Quiz is done", message: "\(self.correctAnswersAferCheck) are correct from \(self.question.count)", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            self.exitAction()
        }
        alertController.addAction(exitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func exitAction() {
        self.question.removeAll()
        self.answers.removeAll()
        self.correctAnswer.removeAll()
        self.selectedAnswers.removeAll()
        Coordinator.closeAnotherScreen(from: self)
    }
    
    func checkAnswer(selectedAnswer: [[Int16]], correctAnswer: [[Int16]]) {
        for counter in 0...question.count-1 {
            if arraysContainSameElements(selectedAnswer[counter], correctAnswer[counter]) {
                correctAnswersAferCheck+=1
            }
        }
    }
    
    func arraysContainSameElements(_ array1: [Int16], _ array2: [Int16]) -> Bool {
        let sortedArray1 = array1.sorted()
        let sortedArray2 = array2.sorted()
        return sortedArray1 == sortedArray2
    }
}
