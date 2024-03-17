import UIKit

struct Quiz {
    var question: String
    var answers: [String]
    var correctAnswerNum: [UInt16] = []
    
    func checkAnswer(selectedAnswer: [UInt16]) -> Bool {
        return correctAnswerNum == selectedAnswer
    }
}
