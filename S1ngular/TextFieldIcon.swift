//
//  InputIconView.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit


class TextFieldIcon: UIView {
    
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = ColoresTexto.TXTMain.cgColor
        let placeholder:String = self.textField.placeholder != nil ? self.textField.placeholder! : ""
        self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSForegroundColorAttributeName: ColoresTexto.TXTMainAlpha])
    }

   
}
