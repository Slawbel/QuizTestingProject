import UIKit
import SnapKit

class WelcomeScreen: UIViewController {
    
    let playButton = UIButton()
    let editButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#000000")
        
        playButton.layer.cornerRadius = 100
        playButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"#EBF400")
        playButton.setTitleColor(.black, for: .normal)
        playButton.addAction(UIAction {_ in 
            let quizScreen = QuizScreen()
            Coordinator.openAnotherScreen(from: self, to: quizScreen)
        }, for: .primaryActionTriggered)
        
        
        editButton.layer.cornerRadius = 25
        editButton.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"#EBF400")
        editButton.setTitleColor(.black, for: .normal)
        
        
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

