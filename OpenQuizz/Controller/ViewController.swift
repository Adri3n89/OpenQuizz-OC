//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Adrien PEREA on 15/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragQuestionView(_ sender:UIPanGestureRecognizer) {
        if game.state == .ongoing {
        switch sender.state {
        case .began, .changed:
            transformQuestionViewWith(gesture: sender)
        case .ended, .cancelled:
            answerQuestion()
        default:
            break
        }
        }
    }
    
    private func transformQuestionViewWith (gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth/2)
        let rotation = (CGFloat.pi/6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotation)
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        transformScore()
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.questionView.transform = translationTransform
        } completion: { (succes) in
            if succes {
                self.showQuestionView()
            }
        }
    }
    
    func transformScore(){
        scoreLabel.transform = .identity
        scoreLabel.text = "\(game.score) / 10"
        scoreLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UILabel.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations:{self.scoreLabel.transform = .identity  }, completion: nil)
    }
    
    
    private func showQuestionView(){
        questionView.transform = .identity
        questionView.style = .standard
        questionView.transform = .init(scaleX: 0.01, y: 0.01)
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
            congratLabel.isHidden = true
        case .over:
            questionView.title = "Game Over"
            congratLabel.isHidden = false
            if game.score >= 5 {
                congratLabel.text = "Toutes mes Félicitations !"
            } else {
                congratLabel.text = "Dommage, essaie encore !"
            }
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations:{ self.questionView.transform = .identity
        }, completion: nil)
        
    }

    
    
   @objc func questionsLoaded() {
    activityIndicator.isHidden = true
    newGameButton.isHidden = false
    questionView.title = game.currentQuestion.title
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    @IBOutlet weak var congratLabel: UILabel!
    
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame(){
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        questionView.title = "Loading..."
        questionView.style = .standard
        scoreLabel.text = "0 / 10"
        game.refresh()
        congratLabel.isHidden = true
        
    }
    
}

