//
//  PopularInstructionViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 08.05.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class PopularInstructionViewController: UIViewController {

    @IBOutlet weak var popularInstructionImageView: UIImageView!
    @IBOutlet weak var popularInstructionLabel: UILabel!
    @IBOutlet weak var popularHeaderLabel: UILabel!
    @IBOutlet weak var popularInstructionPageControl: UIPageControl!
    
    var header = ""
    var label = ""
    var imageFile = ""
    var index = 0
    var position = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popularHeaderLabel.text = header
        popularInstructionLabel.text = label
        popularInstructionImageView.image = UIImage(named: imageFile)
        
        popularInstructionPageControl.numberOfPages = position
        popularInstructionPageControl.currentPage = index
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
