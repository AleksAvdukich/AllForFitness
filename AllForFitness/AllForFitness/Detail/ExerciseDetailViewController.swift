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
    var train: Training?
    var imageName = "" // Передача с 1-го ViewController названия изображения.
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false // Не прячем Navigation Bar при проматывании вниз.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = train!.name // В Navigation Bar отображается название тренировки. Это название имеет цвет и шрифт такой, какой прописали в AppDelegate.swift.
        imageView.image = UIImage(named: train!.image) // Отображение изображения упражнения.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
