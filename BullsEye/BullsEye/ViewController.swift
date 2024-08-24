//
//  ViewController.swift
//  BullsEye
//
//  Created by Mohsin Ali Ayub on 17.06.24.
//

import UIKit

class ViewController: UIViewController {
    
    /// Label to display the target value for the user to guess.
    @IBOutlet var targetLabel: UILabel!
    /// Label to display total score across all rounds played.
    @IBOutlet var scoreLabel: UILabel!
    /// Label to display the number of rounds played by the user.
    @IBOutlet var roundLabel: UILabel!
    /// Slider to guess the target value. Drag it to try to match the target value.
    @IBOutlet var slider: UISlider!
    
    /// The slider's current value, rounded down to nearest integer or an even.
    var currentValue = 0
    /// The target value the user has to match by dragging the slider.
    var targetValue = 0
    /// Keeps track of user's total score. The score is calculated across multiple rounds.
    var score = 0
    /// Keeps track of total rounds played.
    var round = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startNewRound()
    }
    
    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        score += points
        
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true) {
            self.startNewRound()
        }
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value.rounded(.toNearestOrEven))
    }
    
    private func startNewRound() {
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        round += 1
        
        updateLabels()
    }
    
    private func updateLabels() {
        slider.value = Float(currentValue)
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }

}

