//
//  RateViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 12.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    var trainRating: String?
    
    @IBAction func rateTrain(sender: UIButton) {
        switch sender.tag {
        case 0: trainRating = "like"
        case 1: trainRating = "dislike"
        default: break
        }
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender) // Принудительный переход в обратную сторону. Срабатывает @IBAction unwindSegueToDetailViewController в ExerciseDetailViewController, т.к. именно его вызывает сигвэй с идентификатором "unwindSegueToDVC".
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Эффект нечеткости картинки imageView в RateViewController.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.insertSubview(blurEffectView, at: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
