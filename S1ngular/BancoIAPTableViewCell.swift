//
//  BancoIAPTableViewCell.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 06/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class BancoIAPTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coinTitle: UILabel!
    @IBOutlet weak var coinPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
