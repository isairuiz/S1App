//
//  CheckInTableViewCell.swift
//  S1ngular
//
//  Created by Akira Redwolf on 15/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class CheckInTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var badge: UILabel!    
    @IBOutlet weak var compartirFacebookButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        badge.layoutIfNeeded()
        badge.layer.cornerRadius = badge.bounds.height / 2
        badge.clipsToBounds = true
        
        compartirFacebookButton.layoutIfNeeded()
        compartirFacebookButton.layer.cornerRadius = compartirFacebookButton.bounds.height / 2
        compartirFacebookButton.clipsToBounds = true
        
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
