import UIKit
import SnapKit

class WelcomeScreen: UIViewController {
    
    private let playButton = UIButton()
    private let editButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexWelcScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexWelcScreen)

        //view.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#000000")
        
        playButton.layer.cornerRadius = 100
        playButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        playButton.alpha = 0.3
        playButton.setTitleColor(.white, for: .normal)
        playButton.addAction(UIAction {_ in
            let quizScreen = QuizScreen()
            Coordinator.openAnotherScreen(from: self, to: quizScreen)
        }, for: .primaryActionTriggered)
        
        
        editButton.layer.cornerRadius = 25
        editButton.alpha = 0.3
        editButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        editButton.setTitleColor(.white, for: .normal)
        editButton.addAction(UIAction {_ in
            let newQuestionsScreen = NewQuestionsScreen()
            Coordinator.openAnotherScreen(from: self, to: newQuestionsScreen)
        }, for: .primaryActionTriggered)
        
        
        view.addSubview(playButton)
        view.addSubview(editButton)
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(440)
            make.width.height.equalTo(200)
        }
        
        editButton.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(700)
            make.height.equalTo(50)
            make.width.equalTo(340)
        }
        
    }
}

extension UINavigationController {
    func setupNavigationBarTextColor() {
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = .black
        self.navigationBar.isTranslucent = false
    }
}

