import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate

{
    // MARK: - Lifecycle
    
    struct ViewModel {
        let image: UIImage
        let qustions: String
        let questionNumber: String
    }
    
    
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    private  func show(quiz step: QuizStepViewModel) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        print(NSHomeDirectory())
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenterImp1(viewController: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.requestNextQuestion()
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileName = "inception.json"
//        documentsURL.appendPathComponent(fileName)
//        let jsonString = try? String(contentsOf: documentsURL)
//        guard let data = jsonString?.data(using: .utf8) else {
//            return
//        }
        }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            show(quiz: viewModel)
        DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
            
    }

        
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
       
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect == true {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
        }
    }
        private func showNextQuestionOrResult() {
            if currentQuestionIndex == questionsAmount - 1 {
                showFinalResults()
            }
            else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
            }
        }
    
    private  func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        
        
        
        let alertModel = AlertModel(title: "Игра окончена",
                                    message: makeResultMessage(),
                                    buttonText: "Ok",
                                    buttonAction: { [weak self] in
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(alertModel: alertModel)
 
         }
    private func makeResultMessage() -> String {
        
        guard let statisticService = statisticService,
            let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
       let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlayCountLine = "Количество сыгранных квизов: \( statisticService.gamesCount))"
        let currentGamesResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [
            currentGamesResultLine, totalPlayCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        return resultMessage
    }
    
    }
    
