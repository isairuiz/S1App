//
//  TipView.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class TipView: UIView {
    
    var color:CGColor?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.color = Colores.TabBar.cgColor
    }
    
    init(frame: CGRect, color:CGColor) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.color = color
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.color!)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: rect.width, y: 0))
        context?.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        context?.fillPath()
    }
    
    
}

