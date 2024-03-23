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
    private var correctAnswer: [[Int8]] = []
    
    private var quizModels: Results<QuizModel>?
    private var currentQuestionIndex = 0
    private var selectedAnswers: [[Int8]] = []
    private var correctAnswersAfterCheck: Int = 0
    var sourceSelector: Bool
        
    init(decision: Bool) {
        self.sourceSelector = decision
        super.init(nibName: nil, bundle: nil)
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
        
        // API or Realm - what data will be donwloaded depeneds on sourceSelector
        if sourceSelector {
            parsingJSONData()
        } else {
            retrieveData()
        }
        
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
            
        if currentQuestionIndex < answers.count {
            let currentAnswers = answers[currentQuestionIndex]
                    
            if indexPath.row < currentAnswers.count {
                cell.answerText.text = currentAnswers[indexPath.row]
            }
 
                    
            if !selectedAnswers.isEmpty && currentQuestionIndex < selectedAnswers.count {
                let selectedIndices = selectedAnswers[currentQuestionIndex]
                if selectedIndices.contains(Int8(indexPath.row + 1)) {
                    cell.answerNum.backgroundColor = .gray
                }
            }
        }
        
        
        cell.answerNum.backgroundColor = .white
        
        cell.addActionClosure = { [weak self] in
            guard let self = self else { return }
                
            print("Current # of question is: \(currentQuestionIndex + 1)")
            print("What question is this question: \(question[currentQuestionIndex])")
            print("What answers are included to this question: \(answers[currentQuestionIndex])")
            print("What correct answers are: \(correctAnswer[currentQuestionIndex])")
            
            
            let selectedAnswer = Int8(indexPath.row + 1)
            if self.currentQuestionIndex < self.selectedAnswers.count {
                if self.selectedAnswers[self.currentQuestionIndex].contains(selectedAnswer) {
                    // Answer already selected, so remove it
                    self.removeSelectedAnswer(selectedAnswer)
                    cell.answerNum.backgroundColor = .white
                } else {
                    // Answer not selected, so add it
                    self.addSelectedAnswers(selectedAnswer)
                    cell.answerNum.backgroundColor = .gray
                    print("What answer was selected: \(selectedAnswers[currentQuestionIndex])")
                }
            }
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 350
        let height: CGFloat = 70
        return CGSize(width: width, height: height)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Quiz is done", message: "\(self.correctAnswersAfterCheck) are correct from \(self.question.count)", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            self.exitAction()
        }
        alertController.addAction(exitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func retrieveData() {
        do {
            let realm = try Realm()
            let quizModels = realm.objects(QuizModel.self)
            
            self.question = quizModels.map { $0.question }
            self.answers = quizModels.map { [$0.answer1, $0.answer2, $0.answer3, $0.answer4] }
            
            self.correctAnswer = quizModels.map { model in
                var answers: [Int8] = []
                answers.append(model.corAnswer1)
                if let corAnswer2 = model.CorAnswer2 {
                    answers.append(corAnswer2)
                }
                if let corAnswer3 = model.CorAnswer3 {
                    answers.append(corAnswer3)
                }
                return answers
            }
            
            createEmptySelectedAnswers()
            
        } catch {
            print("Error retrieving data: \(error)")
        }
    }

    func setDataToScreen() {
        if currentQuestionIndex < question.count {
            questionLabel.text = question[currentQuestionIndex]
            counterLabel.text = "\(currentQuestionIndex + 1) from \(question.count)"
        } else {
            // Handle the case when currentQuestionIndex exceeds the bounds of the question array
            // For example, reset the UI elements or display an error message
            print("Error: currentQuestionIndex is out of bounds")
        }
    }
    
    func exitAction() {
        Coordinator.closeAnotherScreen(from: self)
    }
    
    private func createEmptySelectedAnswers() {
        self.selectedAnswers = Array(repeating: [], count: question.count)
    }
}

// MARK: - parsing of JSON data
extension QuizScreen {
    func parsingJSONData() {
        guard let url = URL(string: "https://api.npoint.io/536a72fc9ad7ef5dfe69") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching JSON data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonArray = json as? [[String: Any]] {
                    self.processJSONData(jsonArray)
                }
            } catch {
                print("Error parsing JSON data: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Inside processJSONData()
    func processJSONData(_ jsonArray: [[String: Any]]) {
        // Clear previous data
        self.question.removeAll()
        self.answers.removeAll()
        self.correctAnswer.removeAll()
        // Iterate over JSON array and process quiz questions and answers
        for jsonDict in jsonArray {
            if let question = jsonDict["question"] as? String,
               let answers = jsonDict["answers"] as? [String],
               let correctAnswer = jsonDict["correctAnswer"] as? [Int8] {
                self.question.append(question)
                self.answers.append(answers)
                self.correctAnswer.append(correctAnswer.map { Int8($0) })
                // Process each quiz question
                print("Question: \(question)")
                print("Answers: \(answers)")
                print("Correct Answer Indices: \(correctAnswer)")
                print("-----")
            }
        }
        createEmptySelectedAnswers()
        DispatchQueue.main.async {
            self.setDataToScreen()
            self.collectionView.reloadData() // Reload collection view to reflect new data
        }
    }
}

// MARK: - check of answer
extension QuizScreen {
    func checkAnswer(selectedAnswer: [[Int8]], correctAnswer: [[Int8]]) {
        guard selectedAnswer.count == correctAnswer.count else {
            print("Error: The number of questions in selectedAnswer and correctAnswer arrays are different.")
            return
        }

        for counter in 0..<selectedAnswer.count {
            guard counter < selectedAnswer.count && counter < correctAnswer.count else {
                print("Error: Index out of range in selectedAnswer or correctAnswer array.")
                return
            }

            if arraysContainSameElements(selectedAnswer[counter], correctAnswer[counter]) {
                correctAnswersAfterCheck += 1
            }
        }
    }
    
    private func arraysContainSameElements(_ array1: [Int8], _ array2: [Int8]) -> Bool {
        let sortedArray1 = array1.sorted()
        let sortedArray2 = array2.sorted()
        return sortedArray1 == sortedArray2
    }
}

// MARK: - selection and deselection of answer
extension QuizScreen {
    private func addSelectedAnswers(_ numOfSelectedAnswer: Int8) {
        guard currentQuestionIndex < selectedAnswers.count else {
            print("Error: currentQuestionIndex is out of bounds of selectedAnswers array.")
            return
        }
        selectedAnswers[currentQuestionIndex].append(Int8(numOfSelectedAnswer))
    }
    
    private func removeSelectedAnswer(_ selectedAnswer: Int8) {
        guard currentQuestionIndex < selectedAnswers.count else {
            print("Error: currentQuestionIndex is out of bounds of selectedAnswers array.")
            return
        }
        if let index = selectedAnswers[currentQuestionIndex].firstIndex(of: selectedAnswer) {
            selectedAnswers[currentQuestionIndex].remove(at: index)
        } else {
            print("Error: Selected answer not found in selectedAnswers array.")
        }
    }
}

// MARK: - changing of questions on the screen
extension QuizScreen {
    @objc func previousButtonTapped() {
        if currentQuestionIndex > 0 {
            self.currentQuestionIndex -= 1
            if currentQuestionIndex != question.count - 1 {
                nextButton.isHidden = false
            }
            if currentQuestionIndex < selectedAnswers.count {
                setDataToScreen()
                collectionView.reloadData()
            }
        }
        self.hidePreviousButton()
    }

    @objc func nextButtonTapped() {
        if currentQuestionIndex < question.count - 1 {
            self.currentQuestionIndex += 1
            if currentQuestionIndex != 0 {
                previousButton.isHidden = false
            }
            if currentQuestionIndex < selectedAnswers.count {
                setDataToScreen()
                collectionView.reloadData()
            }
        }
        if currentQuestionIndex == question.count - 1 {
            nextButton.isHidden = true
        }
    }
    
    private func hidePreviousButton() {
        if currentQuestionIndex == 0 {
            previousButton.isHidden = true
        }
    }
}
