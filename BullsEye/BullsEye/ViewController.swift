//
//  ViewController.swift
//  BullsEye
//
//  Created by Mohsin Ali Ayub on 17.06.24.
//

import UIKit

class ViewController: UIViewController {
    
    /// The slider's current value.
    var currentValue = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)"
        
        let alert = UIAlertController(
            title: "Hello, World",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value.rounded(.toNearestOrEven))
    }

}

