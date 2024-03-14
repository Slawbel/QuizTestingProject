import UIKit
import SnapKit

class QuizScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let counterLabel = UILabel()
    private let questionLabel = UILabel()
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexQuizScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexQuizScreen)
        
        counterLabel.alpha = 0.3
        counterLabel.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        counterLabel.textColor = .white
        counterLabel.layer.cornerRadius = 30
        counterLabel.clipsToBounds = true
        
        questionLabel.alpha = 0.3
        questionLabel.backgroundColor = SetColorByCode.hexStringToUIColor(hex:"000000")
        questionLabel.textColor = .white
        questionLabel.layer.cornerRadius = 50
        questionLabel.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorInset = .zero
        tableView.backgroundColor = .clear
        tableView.alpha = 0.3
        tableView.isScrollEnabled = false
        
        tableView.register(AnswersCell.self, forCellReuseIdentifier: "AnswersCell")
        
        view.addSubview(counterLabel)
        view.addSubview(questionLabel)
        view.addSubview(tableView)
        
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(70)
            make.width.height.equalTo(60)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(150)
            make.height.equalTo(250)
            make.width.equalTo(340)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(450)
            make.width.equalTo(340)
            make.height.equalTo(350)
            make.centerX.equalTo(view)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersCell", for: indexPath) as? AnswersCell
        
        cell?.layer.cornerRadius = 35
        cell?.backgroundColor = .black
        
        // to allow customization of selection style in class AnswersCell
        cell?.selectionStyle = .none
        
        return cell!
    }
}


