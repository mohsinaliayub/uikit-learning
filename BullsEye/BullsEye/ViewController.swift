//
//  ViewController.swift
//  BullsEye
//
//  Created by Mohsin Ali Ayub on 17.06.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    
    /// The slider's current value, rounded down to nearest integer or an even.
    var currentValue = 0 {
        didSet {
            slider.value = Float(currentValue)
        }
    }
    /// The target value the user has to match by dragging the slider.
    var targetValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startNewRound()
    }
    
    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)" +
                      "\nThe target value is: \(targetValue)"
        
        let alert = UIAlertController(
            title: "Hello, World",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
        
        startNewRound()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value.rounded(.toNearestOrEven))
    }
    
    private func startNewRound() {
        targetValue = Int.random(in: 1...100)
        currentValue = 50
    }

}

