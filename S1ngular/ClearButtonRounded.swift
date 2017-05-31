//
//  ClearButtonRounded.swift
//  S1ngular
//
//  Created by Akira Redwolf on 09/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//


import UIKit


class ClearButtonRounded: UIButton {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = ColoresTexto.TXTMain.cgColor
        self.backgroundColor = UIColor.clear
        
       
        self.setTitleColor(ColoresTexto.TXTMain, for: UIControlState.normal)
        self.setTitleColor(ColoresTexto.TXTMainAlpha, for: UIControlState.highlighted)
        
        self.titleLabel?.font = UIFont(name: "BrandonGrotesque-Medium", size: 19)
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.bounds.size.height / 2, bottom: 0, right: self.bounds.size.height / 2)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}
