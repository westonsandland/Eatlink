//
//  TopRestaurantsTableViewCell.swift
//  Eatlink
//
//  Created by Weston Sandland on 5/13/17.
//  Copyright © 2017 Sandland Apps. All rights reserved.
//

import UIKit

class TopRestaurantsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
