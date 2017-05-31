//
//  S1ngularesTableViewCell.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class S1ngularesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    var tipo:Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        badge.layoutIfNeeded()
        
        badge.layer.cornerRadius = badge.bounds.height / 2
        badge.layer.borderWidth = 2
        badge.layer.borderColor = Colores.MainCTA.cgColor
        badge.clipsToBounds = true
        
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// actualizarTipo: Esta función cambia el estilo de la celda.
    /// - Parameter tipo: Existen *3 tipos*: **1)** Fondo gris con *badge* numérico. **2)** Fondo gris sin *badge* y *texto del chat* gris claro. **3)** Fondo rosa con texto blanco y *badge* con signo de exclamación
    /// - Returns: Void
    func actualizarTipo(_ tipo:Int){
        switch(tipo){
        case 2:
            texto.textColor = ColoresTexto.TXTSecondary
            distancia.textColor = ColoresTexto.TXTSecondary
            
            badge.isHidden = true
            badge.backgroundColor = UIColor.clear
            badge.layer.borderWidth = 2
            
            view.backgroundColor = Colores.MainK
            
            break
        case 3:
            texto.textColor = ColoresTexto.Gray
            distancia.textColor = ColoresTexto.TXTMain
            
            badge.backgroundColor = Colores.TabBar
            badge.textColor = ColoresTexto.Pink
            badge.text = "!"
            badge.isHidden = false
            badge.layer.borderWidth = 0
            
            view.backgroundColor = Colores.MainCTA
            break
        default:
            texto.textColor = ColoresTexto.Pink
            distancia.textColor = ColoresTexto.TXTSecondary
            
            badge.isHidden = false
            badge.backgroundColor = UIColor.clear
            badge.layer.borderWidth = 2
            
            view.backgroundColor = Colores.MainK
            break
        }
    }
    
}
