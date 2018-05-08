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
    @IBOutlet weak var cancel: UIButton!
    
    var trainRating: String?
    var id: Double?
    
    @IBAction func rateTrain(sender: UIButton) {
        switch sender.tag {
        case 0: trainRating = "like"
        case 1: trainRating = "dislike"
        case 2: trainRating = "ratingLikeDislike"
        default: break
        }
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let rating = Rating(context: context)
            rating.image = trainRating
            rating.id = id!
            do {
                try context.save()
                print("Сохранение удалось!")
            } catch let error as NSError {
                print("Не удалось сохранить данные: \(error), \(error.userInfo)")
            }
        }
        
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender) // Принудительный переход в обратную сторону. Срабатывает @IBAction unwindSegueToDetailViewController в ExerciseDetailViewController, т.к. именно его вызывает сигвэй с идентификатором "unwindSegueToDVC".
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Рамка для кнопок.
        let buttons = [like, dislike, cancel]
        for button in buttons {
            guard let button = button else { break }
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.blue.cgColor
        }

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
