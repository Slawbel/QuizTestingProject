import UIKit
import SnapKit
import RealmSwift

class WelcomeScreen: UIViewController {
    
    private let playAPIButton = UIButton()
    private let playCustomQuizButton = UIButton()
    private let addQuestionButton = UIButton()
    private let deleteQuestionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexWelcScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexWelcScreen)

        playAPIButton.layer.cornerRadius = 100
        playAPIButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        playAPIButton.alpha = 0.3
        playAPIButton.setTitleColor(.white, for: .normal)
        playAPIButton.addAction(UIAction {_ in
            let quizScreen = QuizScreen(decision: true)
            Coordinator.openAnotherScreen(from: self, to: quizScreen)
        }, for: .primaryActionTriggered)
        playAPIButton.setTitle("API Quiz", for: .normal)
        playAPIButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        
        playCustomQuizButton.layer.cornerRadius = 100
        playCustomQuizButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        playCustomQuizButton.alpha = 0.3
        playCustomQuizButton.setTitleColor(.white, for: .normal)
        playCustomQuizButton.addAction(UIAction {_ in
            if self.isRealmEmpty() {
                self.showAlert()
            } else {
                let quizScreen = QuizScreen(decision: false)
                Coordinator.openAnotherScreen(from: self, to: quizScreen)
            }
        }, for: .primaryActionTriggered)
        playCustomQuizButton.setTitle("My Quiz", for: .normal)
        playCustomQuizButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        
        addQuestionButton.layer.cornerRadius = 25
        addQuestionButton.alpha = 0.3
        addQuestionButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        addQuestionButton.setTitleColor(.white, for: .normal)
        addQuestionButton.addAction(UIAction {_ in
            let newQuestionsScreen = NewQuestionsScreen()
            Coordinator.openAnotherScreen(from: self, to: newQuestionsScreen)
        }, for: .primaryActionTriggered)
        addQuestionButton.setTitle("Add question", for: .normal)
        addQuestionButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        
        deleteQuestionButton.layer.cornerRadius = 25
        deleteQuestionButton.alpha = 0.3
        deleteQuestionButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        deleteQuestionButton.setTitleColor(.white, for: .normal)
        deleteQuestionButton.addAction(UIAction {_ in
           
        }, for: .primaryActionTriggered)
        deleteQuestionButton.setTitle("Delete question", for: .normal)
        deleteQuestionButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        
        
        view.addSubview(playAPIButton)
        view.addSubview(playCustomQuizButton)
        view.addSubview(addQuestionButton)
        view.addSubview(deleteQuestionButton)
        
        playAPIButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(150)
            make.width.height.equalTo(200)
        }
        
        playCustomQuizButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(400)
            make.width.height.equalTo(200)
        }
        
        addQuestionButton.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(660)
            make.height.equalTo(50)
            make.width.equalTo(340)
        }
        
        deleteQuestionButton.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(730)
            make.height.equalTo(50)
            make.width.equalTo(340)
        }
    }
    
    func isRealmEmpty() -> Bool {
        do {
            let realm = try Realm()
            let objectsCount = realm.objects(QuizModel.self).count
            return objectsCount == 0
        } catch {
            print("Error accessing Realm database: \(error.localizedDescription)")
            return true // Consider database empty if there's an error accessing it
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "No questions added", message: "Add them below", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            print("No questions in Realms database")
        }
        alertController.addAction(exitAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


