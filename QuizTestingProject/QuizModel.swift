import RealmSwift

class QuizModel: Object {
    @Persisted var question: String = ""
    @Persisted var answer1: String = ""
    @Persisted var answer2: String = ""
    @Persisted var answer3: String = ""
    @Persisted var answer4: String = ""
    @Persisted var corAnswer1: Int8
    @Persisted var CorAnswer2: Int8?
    @Persisted var CorAnswer3: Int8?
    
    
    convenience init(question: String, answers: [String], correctAnswer: [Int8]) {
        self.init()
        self.question = question
        self.answer1 = answers[0]
        self.answer2 = answers[1]
        self.answer3 = answers[2]
        self.answer4 = answers[3]
        self.corAnswer1 = correctAnswer[0]
        self.CorAnswer2 = correctAnswer.count > 1 ? correctAnswer[1] : nil
        self.CorAnswer3 = correctAnswer.count > 2 ? correctAnswer[2] : nil
    }
}




