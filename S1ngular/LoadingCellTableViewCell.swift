//
//  LoadingCellTableViewCell.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 07/07/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class LoadingCellTableViewCell: UITableViewCell {

    @IBOutlet weak var loaderMessage: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
