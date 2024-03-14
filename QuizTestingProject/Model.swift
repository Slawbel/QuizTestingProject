import UIKit

struct Quiz {
    var question: String
    var answers: [String]
    var correctAnswerNum: UInt8
    
    func checkAnswer(selectedAnswer: UInt8) -> Bool {
        return correctAnswerNum == selectedAnswer
    }
}
