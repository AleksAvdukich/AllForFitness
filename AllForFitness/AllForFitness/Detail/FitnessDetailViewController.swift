//
//  FitnessDetailViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FitnessDetailViewController: UIViewController {

    var train: Training?
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false // Не прячем Navigation Bar при проматывании вниз.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = train!.name // В Navigation Bar отображается имя ресторана. Это имя имеет цвет и шрифт такой, какой прописали в AppDelegate.swift.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
