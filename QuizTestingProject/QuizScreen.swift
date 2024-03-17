import UIKit
import SnapKit
import CoreData

class QuizScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let counterLabel = UILabel()
    private let questionLabel = PaddingLabel()
    private var collectionView: UICollectionView!
    private let backButton = UIButton()
    private let finishButton = UIButton()
    
    private var newQuestion: Quiz?
    
    private var question: String = ""
    private var answers: [String] = []
    private var correctAnswer: [Int16] = []
    
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
        
        finishButton.alpha = 0.3
        finishButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        finishButton.layer.cornerRadius = 20
        finishButton.setTitle("Finish", for: .normal)
        
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
        questionLabel.edgeInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

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
        
        returnData()
        
        view.addSubview(backButton)
        view.addSubview(finishButton)
        view.addSubview(counterLabel)
        view.addSubview(questionLabel)
        view.addSubview(collectionView)
        
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
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
    
    func returnData() {
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
        }

}


