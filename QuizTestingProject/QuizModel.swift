import RealmSwift

class QuizModel: Object {
    @Persisted var question: String = ""
    let options = List<QuizOption>()
    let correctAnswers = List<Int16>()  // Store indices of correct answers
    let answers = List<String>()        // Store answers as strings
    
    convenience init(question: String, answers: [String], correctAnswer: [Int16]) {
        self.init()
        self.question = question
        for answer in answers {
            let realmOption = QuizOption()
            realmOption.text = answer
            self.options.append(realmOption)
            self.answers.append(answer)  // Add answer to List
        }
        self.correctAnswers.append(objectsIn: correctAnswer)
    }
}



class QuizOption: Object {
    @Persisted var text: String = ""
}



