//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Виктор Корольков on 20.08.2023.
//

import Foundation
import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {

    
        let questionsAmount: Int = 10
        var currentQuestionIndex: Int = 0
        var currentQuestion: QuizQuestion?
        weak var viewController: MovieQuizViewController?
        var correctAnswers: Int = 0
        var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
    
    func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
       func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
    
    func didAnswer(isCorrectAnswer: Bool) {
            if isCorrectAnswer {
                correctAnswers += 1
            }
        }
    
      func yesButtonClicked() {
            didAnswer(isYes: true)
    }
    
       func noButtonClicked() {
           didAnswer(isYes: false)
    }
    
      func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = isYes
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"

            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
    
    func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
    
    func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
