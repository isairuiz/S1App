//
//  TabView.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class TabView: UIView {
    
    var botonIzquierda:UIButton?
    var botonDerecha:UIButton?
    var tip:TipView!
    var textoBotonIzquierda = ""
    var textoBotonDerecha = ""
    
    var _tabSeleccionada:Int = 0
    var tabSeleccionada: Int {
        get {
            return _tabSeleccionada
        }
        /*set{
            _tabSeleccionada = tabSeleccionada
        }*/
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.botonIzquierda = UIButton(frame: CGRect(x: 8, y: 8, width: (self.frame.width - 16) / 2, height: self.frame.height - 20))
        self.botonDerecha = UIButton(frame: CGRect(x: 8 + ((self.frame.width - 16) / 2), y: 8, width: (self.frame.width - 16) / 2, height: self.frame.height - 20))
        self.tip = TipView(frame: CGRect(x: ((self.botonIzquierda?.frame.size.width)! / 2), y: self.frame.height - 12, width: 16, height: 8), color: Colores.TabBar.cgColor)
        
        self.botonIzquierda?.backgroundColor = Colores.TabBar
        self.botonIzquierda?.layer.borderColor = Colores.TabBar.cgColor
        self.botonIzquierda?.layer.borderWidth = 1
        
        
        self.botonDerecha?.backgroundColor = UIColor.clear
        self.botonDerecha?.layer.borderWidth = 1
        self.botonDerecha?.layer.borderColor = Colores.TabBar.cgColor
        
        
        
        
        self.botonIzquierda?.layer.shadowColor = UIColor.black.cgColor
        self.botonIzquierda?.layer.shadowOpacity = 0.5
        self.botonIzquierda?.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.botonIzquierda?.layer.shadowRadius = 3
        
        self.botonDerecha?.layer.shadowColor = UIColor.black.cgColor
        self.botonDerecha?.layer.shadowOpacity = 0.5
        self.botonDerecha?.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.botonDerecha?.layer.shadowRadius = 3
        
        
        self.addSubview(self.botonIzquierda!)
        self.addSubview(self.botonDerecha!)
        self.addSubview(self.tip!)
        
        
        self.botonIzquierda?.addTarget(self, action: #selector(self.activarBotonIzquierda), for: UIControlEvents.touchUpInside)
        self.botonDerecha?.addTarget(self, action: #selector(self.activarBotonDerecha), for: UIControlEvents.touchUpInside)
        
        
        
        
    }
    
    func activarBotonIzquierda(){
        self._tabSeleccionada = 0
        
        self.tip!.frame =  CGRect(x: ((self.botonIzquierda?.frame.size.width)! / 2), y: self.frame.height - 12, width: 16, height: 8)
        
        self.botonIzquierda?.backgroundColor = Colores.TabBar
        self.botonDerecha?.backgroundColor = UIColor.clear
        
        
        let fontBlack =   UIFont(name: "BrandonGrotesque-Black", size: 19)!
        
        let stringIzquierda = NSAttributedString(string: self.textoBotonIzquierda, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: Colores.MainK])
        let stringIzquierdaHighlighted = NSAttributedString(string: self.textoBotonIzquierda, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: Colores.MainKAlpha])
        
        let stringDerecha = NSAttributedString(string: textoBotonDerecha, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: ColoresTexto.TXTMain])
        let stringDerechaHighlighted = NSAttributedString(string: textoBotonDerecha, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: ColoresTexto.TXTMainAlpha])
        
        self.botonIzquierda?.setAttributedTitle(stringIzquierda, for: UIControlState())
        self.botonIzquierda?.setAttributedTitle(stringIzquierdaHighlighted, for: UIControlState.highlighted)
        self.botonDerecha?.setAttributedTitle(stringDerecha, for: UIControlState())
        self.botonDerecha?.setAttributedTitle(stringDerechaHighlighted, for: UIControlState.highlighted)
    }
    
    func activarBotonDerecha(){
        self._tabSeleccionada = 1
        
        self.tip!.frame =  CGRect(x: ( (self.botonDerecha?.frame.origin.x)! - 8  + (self.botonDerecha?.frame.size.width)! / 2) , y: self.frame.height - 12, width: 16, height: 8)
        
        self.botonIzquierda?.backgroundColor = UIColor.clear
        self.botonDerecha?.backgroundColor = Colores.TabBar
        
        
        let fontBlack =   UIFont(name: "BrandonGrotesque-Black", size: 19)!
        
        let stringIzquierda = NSAttributedString(string: self.textoBotonIzquierda, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: ColoresTexto.TXTMain])
        let stringIzquierdaHighlighted = NSAttributedString(string: self.textoBotonIzquierda, attributes: [NSFontAttributeName :fontBlack, NSForegroundColorAttributeName: ColoresTexto.TXTMainAlpha])
        
        let stringDerecha = NSAttributedString(string: textoBotonDerecha, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: Colores.MainK])
        let stringDerechaHighlighted = NSAttributedString(string: textoBotonDerecha, attributes: [NSFontAttributeName : fontBlack, NSForegroundColorAttributeName: Colores.MainKAlpha])
        
        self.botonIzquierda?.setAttributedTitle(stringIzquierda, for: UIControlState())
        self.botonIzquierda?.setAttributedTitle(stringIzquierdaHighlighted, for: UIControlState.highlighted)
        self.botonDerecha?.setAttributedTitle(stringDerecha, for: UIControlState())
        self.botonDerecha?.setAttributedTitle(stringDerechaHighlighted, for: UIControlState.highlighted)
    }
    
    func actualizarTextoBotones(_ izquierda:String, derecha:String) {
        
        self.textoBotonIzquierda = izquierda
        self.textoBotonDerecha = derecha
        
        activarBotonIzquierda()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
