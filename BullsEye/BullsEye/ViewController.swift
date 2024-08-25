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
        customizeSlider()
        startNewGame()
    }
    
    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        let points = points(basedOn: difference)
        score += points
        
        let title = title(basedOn: difference)
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.startNewRound()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value.rounded(.toNearestOrEven))
    }
    
    @IBAction func startNewGame() {
        score = 0
        round = 0
        startNewRound()
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
    
    private func title(basedOn difference: Int) -> String {
        let title: String
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        return title
    }
    
    private func points(basedOn difference: Int) -> Int {
        var points = 100 - difference
        if difference == 0 {
            points += 100 // an extra 100 bonus points for perfect guess
        } else if difference == 1 {
            points += 50 // extra 50 points for a near-close guess
        }
        
        return points
    }
    
    private func customizeSlider() {
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
}

