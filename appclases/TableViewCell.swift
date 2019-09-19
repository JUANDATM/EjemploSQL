//
//  TableViewCell.swift
//  appclases
//
//  Created by Daniel Torres Moreno on 9/12/19.
//  Copyright © 2019 Daniel Torres Moreno. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var lblSubtitulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
