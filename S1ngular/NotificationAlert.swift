//
//  NotificationAlert.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 08/08/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class NotificationAlert: UIViewController {
    
    @IBOutlet weak var iconAlert: UIImageView!
    let layer = CAShapeLayer()
    let path = CGMutablePath()
    @IBOutlet weak var tituloAlert: UILabel!
    @IBOutlet weak var cuerpoAlert: UILabel!
    @IBOutlet weak var nombrePersona: UILabel!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var imageHeightConst: NSLayoutConstraint!
    
    var tipoNotif = String()
    var tituloNotif = String()
    var cuerpoNotif = String()
    var urlNotif = String()
    var nombreNotif = String()
    var visible:Float? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colores.BGWhiteTransparent
        backView.layer.cornerRadius = 10
        
        self.iconAlert.layer.cornerRadius = self.iconAlert.frame.size.width/2
        self.iconAlert.layer.borderColor = Colores.BGWhite.cgColor as CGColor
        self.iconAlert.layer.borderWidth = 2
        self.iconAlert.clipsToBounds = true
        
        self.continuarBtn.layer.cornerRadius = self.continuarBtn.bounds.size.height / 2
        
        if !tituloNotif.isEmpty{
            self.tituloAlert.text = tituloNotif
        }
        if !cuerpoNotif.isEmpty{
            self.cuerpoAlert.text = cuerpoNotif
        }
        
        /*
         De tipo 2 es que reicibio un S1 de s1ngular
         Sino se recibe ese tipo se quita la imagen y el nombre,
         al constrait de la imagen se la 0 para que el boton continuar
         se recorra hacia arriba.
         */
        if tipoNotif != "2"{
            self.imageHeightConst.constant = 0
            self.nombrePersona.isHidden = true
        }else{
            self.imageHeightConst.constant = 130
            self.nombrePersona.isHidden = false
            if !nombreNotif.isEmpty{
                self.nombrePersona.text = nombreNotif
            }
            if !urlNotif.isEmpty{
                var urlImage = Constantes.BASE_URL
                urlImage+=urlNotif
                imagenPerfil.downloadedFrom(link: urlImage, withBlur: true, maxBlur: 0.0)
            }else{
                imagenPerfil.downloadedFrom(link: "https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg", withBlur: false, maxBlur: 0.0)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionButton(_ sender: Any) {
        if tipoNotif == "2"{
            self.parent?.tabBarController?.selectedIndex = 1
            DataUserDefaults.setPushType(type: "2")
        }else{
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }


}
