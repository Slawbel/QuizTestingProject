import UIKit
import SnapKit
import CoreData

class QuizScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let counterLabel = UILabel()
    private let questionLabel = PaddingLabel()
    private var collectionView: UICollectionView!
    private let backButton = UIButton()
    private let finishButton = UIButton()
    
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    
    private var question: [String] = ["How many mm in cm?", "How many mm in m?", "What is green color?"]
    private var answers: [[String]] = [["10", "100", "0.1", "0,01"], ["10", "100", "0.1", "0,01"], ["A leaf", "Grass", "A cloud", "A stone"]]
    private var correctAnswer: [[Int16]] = [[1], [2], [1,2]]
    
    var currentQuestionCounter = 0
    var selectedAnswers: [[Int16]] = []
    var correctAnswersAferCheck: Int = 0
    var sourceSelector: Bool
    
    init(decision: Bool) {
        self.sourceSelector = decision
        super.init(nibName: nil, bundle: nil)
        selectedAnswers = Array(repeating: [], count: question.count)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        /*if !sourceSelector {
            returnData()
        } else {
            // here should be placing of data from API to collection for the next separation on questio-answers-correctAnswers
        }*/
        
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
        cell.answerText.text = self.answers[self.currentQuestionCounter][indexPath.row]
        
        cell.answerNum.backgroundColor = .white


        
        cell.addActionClosure = { [weak self] in
            guard let self = self else { return }
            self.addSelectedAnswers(Int16(indexPath.row+1))
            cell.answerNum.backgroundColor = .gray
        }
        print(self.currentQuestionCounter)
        print(selectedAnswers)
        print(selectedAnswers[self.currentQuestionCounter])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350 // Adjust the divisor and subtracted value as needed
        let height: CGFloat = 70 // Keep the height constant
        return CGSize(width: width, height: height)
    }
    
    /*func returnData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("Failed to retrieve app delegate")
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizQuestion")
            request.fetchLimit = 1

            request.returnsObjectsAsFaults = false
            
            do {
                let result = try managedContext.fetch(request)
                if let data = result.first as? NSManagedObject {
                    if let instanceQuestion = data.value(forKey: "question") as? String {
                        self.question = instanceQuestion
                    }
                    
                    // Assuming "connectionWithSingleAnswer" is the name of the relationship to the Answer entity
                    if let answers = data.value(forKey: "connectionWithSingleAnswer") as? Set<NSManagedObject> {
                        for answer in answers {
                            if let singleAnswer = answer.value(forKey: "singleAnswer") as? String {
                                self.answers.append(singleAnswer)
                            }
                        }
                    }
                    
                    // Assuming "connectionWithSingleCorrectAnswerNum" is the correct answer relationship
                    if let correctAnswers = data.value(forKey: "connectionWithSingleCorrectAnswerNum") as? Set<NSManagedObject> {
                        for correctAnswer in correctAnswers {
                            if let correctAnswerNum = correctAnswer.value(forKey: "singleCorrectAnswerNum") as? Int16 {
                                self.correctAnswer.append(correctAnswerNum)
                            }
                        }
                    }
                }
                print(newQuestion ?? "")
            } catch {
                print("Failed returning")
            }
        }*/
    
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
