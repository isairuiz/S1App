//
//  AfinidadTableViewCell.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 09/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class AfinidadTableViewCell: UITableViewCell {

    @IBOutlet weak var porcentaje: UILabel!
    @IBOutlet weak var ambito: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.makeLabelRounded(label: porcentaje)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeLabelRounded(label:UILabel){
        label.layer.cornerRadius = 0.5 * label.bounds.size.width
    }

}
