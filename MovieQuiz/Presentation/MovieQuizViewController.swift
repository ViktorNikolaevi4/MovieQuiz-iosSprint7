import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

 //   private var correctAnswers: Int = 0

 //  private var currentQuestionIndex: Int = 0
 //   private let questionsAmount: Int = 10
    private var presenter: MovieQuizPresenter!
  //   var questionFactory: QuestionFactoryProtocol?
 //   private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?

    private var alertPresenter = AlertPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
 //       questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()

   //     questionFactory?.loadData()
        showLoadingIndicator()
    }

  //  // MARK: - QuestionFactoryDelegate

//    func didReceiveNextQuestion(question: QuizQuestion?) {
 //       presenter.didRecieveNextQuestion(question: question)
 //   }
    
//    func didLoadDataFromServer() {
 //       activityIndicator.isHidden = true
 //       questionFactory?.requestNextQuestion()
 //   }
    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
 //   }

    // MARK: - Actions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    // MARK: - Private functions

    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultViewModel) {
    
            let message = presenter.makeResultsMessage()
            
            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.restartGame()
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    

  //      let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
   //         guard let self = self else { return }

   //         self.presenter.resetQuestionIndex()
    //        self.presenter.restartGame()

      //      self.questionFactory?.requestNextQuestion()
   //     }

 //       alertPresenter.show(in: self, model: model)
 //   }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }


    
    func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Попробовать еще раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()
            self.presenter.restartGame()

            self.presenter.restartGame()
        }

        alert.addAction(action)
    }
}
 

