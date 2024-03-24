import UIKit
import SnapKit
import RealmSwift

class DeleteQuestionScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var selectedIndexPath: IndexPath?
    private var question: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsHexWelcScreen = ["#4D1E5F", "#ED62B1", "#F9805D", "#FF8F34"]
        SetColorByCode.applyGradientBackground(to: view, colorsHex: colorsHexWelcScreen)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        
        tableView.register(CellForDeleteQuestions.self, forCellReuseIdentifier: "CellForDeleteQuestions")
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeRight(_:)))
        swipeRightGesture.direction = .right
        
        retrieveData()
        
        view.addSubview(tableView)
        view.addGestureRecognizer(swipeRightGesture)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDeleteQuestions", for: indexPath) as? CellForDeleteQuestions
        
        cell?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cell?.questionLabel.text = question[indexPath.row]
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell?.selectedBackgroundView = bgColorView
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let questionToDelete = question[indexPath.row]
            do {
                let realm = try Realm()
                
                if let quizModel = realm.objects(QuizModel.self).filter("question == %@", questionToDelete).first {
                    try realm.write {
                        realm.delete(quizModel)
                    }
                }
                
                question.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    @objc func doSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            Coordinator.closeAnotherScreen(from: self)
        }
    }
        
    private func deleteCell(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
        
        selectedIndexPath = nil
    }
    
    private func retrieveData() {
        do {
            let realm = try Realm()
            let quizModels = realm.objects(QuizModel.self)
            question.removeAll()
            self.question = quizModels.map { $0.question }
            tableView.reloadData()
        } catch {
            print("Error retrieving data: \(error)")
        }
    }
}
