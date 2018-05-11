//
//  InstructionViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 29.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var instructionImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var instructionPageControl: UIPageControl!
    
    var header = ""
    var label = ""
    var imageFile = ""
    var index = 0
    var position = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = header
        instructionLabel.text = label
        instructionImageView.image = UIImage(named: imageFile)
        
        instructionPageControl.numberOfPages = position
        instructionPageControl.currentPage = index
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
