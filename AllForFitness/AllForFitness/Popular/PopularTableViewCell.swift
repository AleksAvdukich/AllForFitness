//
//  PopularTableViewCell.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 18.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var popularImageView: UIImageView!
    @IBOutlet weak var popularNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
