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
    var currentValue: Int {
        Int(slider.value.rounded(.toNearestOrEven))
    }

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

}

