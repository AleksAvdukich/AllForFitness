//
//  ExerciseDetailViewController.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    var imageName = "" //передача с 1-го viewController названия изображения
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: imageName)//создание из названия изображения imageView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
