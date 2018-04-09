//
//  ContentViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 09.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard // Получение доступа к хранилищу UserDefaults. Используется для того, чтобы проверить, смотрел ли оба слайда (case 0 и case 1) наш пользователь.
            userDefaults.set(true, forKey: "wasWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)).cgColor
        
        switch index {
        case 0: pageButton.setTitle("Дальше", for: UIControlState.normal)
        case 1: pageButton.setTitle("Открыть", for: UIControlState.normal)
        default: break
        }
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
