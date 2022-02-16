//
//  ViewController.swift
//  ReviewTemplate
//
//  Created by Mehedi Hasan on 14/2/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var processButton: UIButton!
    
    @IBOutlet weak var rulesLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countLabel.text = "0"
        
        self.resetButton.layer.cornerRadius = 10
        self.resetButton.clipsToBounds = true
        
        self.processButton.layer.cornerRadius = 12
        self.processButton.clipsToBounds = true
        
        self.countLabel.layer.cornerRadius = 30
        self.countLabel.clipsToBounds = true
        
        self.resetButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        
        self.processButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        self.countLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        self.rulesLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedToIncrease(_ sender: Any) {
       requestReview()
        let count = UserDefaults.standard.integer(forKey: ReviewDefaultsKeys.processCompletedCountKey)
        self.countLabel.text = String(count)
    }
    
    @IBAction func tappedOnReset(_ sender: Any) {
        resetChecks()
        self.countLabel.text = "0"
    }
    
    
}

