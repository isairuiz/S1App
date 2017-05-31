//
//  MakeTransparentHoleOnOverlayView.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 27/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import Foundation
import UIKit

class MakeTransparentHoleOnOverlayView: UIView {
    
    @IBOutlet weak var transparentHoleView: UIView!
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.transparentHoleView != nil {
            // Ensures to use the current background color to set the filling color
            self.backgroundColor?.setFill()
            UIRectFill(rect)
            
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            
            // Make hole in view's overlay
            // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
            path.addRect(transparentHoleView.frame)
            path.addRect(bounds)
            
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
        }
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
