//
//  PopularDetailTableViewCell.swift
//  AllForFitness
//
//  Created by Timur Saidov on 24.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class PopularDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
