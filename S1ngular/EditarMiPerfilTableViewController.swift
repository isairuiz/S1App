//
//  EditarMiPerfilTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 04/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class EditarMiPerfilTableViewController: UITableViewController {


    @IBOutlet weak var floatingView: UIVisualEffectView!
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var escribeSobreTiButton: UIButton!
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var profesion: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var tapViewImage = UIGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingView.backgroundColor = Colores.MainKAlpha
        transformButton(button: self.escribeSobreTiButton)
        
        tapViewImage = UITapGestureRecognizer(target: self, action: #selector(self.gotoMisFotos(sender:)))
        tapViewImage.cancelsTouchesInView = false
        fotoPerfil.addGestureRecognizer(tapViewImage)
        
        
        self.fillWindow()
        
    }
    
    func gotoMisFotos(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifMisFotos"), object: nil)
    }
    
    func fillWindow(){
        let nombre = DataUserDefaults.getDataNombre()
        let profess = DataUserDefaults.getDataProfesion()
        let fotoPerfilUrl = DataUserDefaults.getFotoPerfilUrl()
        if nombre != ""{
            self.nombreUsuario.text = nombre
        }else{
            self.nombreUsuario.text = "Configura tu nombre de usuario"
        }
        if profess != ""{
            self.profesion.text = profess
        }else{
            self.profesion.text = "Configura tu profesion"
        }
        if fotoPerfilUrl != ""{
            self.fotoPerfil.downloadedFrom(link: fotoPerfilUrl,withBlur:false,maxBlur:0)
        }else{
            self.info.isHidden = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientLayer = CAGradientLayer()
        
        self.view.layoutIfNeeded()
        gradientLayer.frame = self.view.bounds
        let color1 = Colores.BGGray.cgColor
        let color2 = Colores.BGPink.cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let view = UIView(frame: self.view.frame)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.tableView.backgroundView = view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func transformButton(button:UIButton){
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = ColoresTexto.TXTMain.cgColor
        button.backgroundColor = UIColor.clear
        
        
        button.setTitleColor(ColoresTexto.TXTMain, for: UIControlState.normal)
        button.setTitleColor(ColoresTexto.TXTMainAlpha, for: UIControlState.highlighted)
        
        button.titleLabel?.font = UIFont(name: "BrandonGrotesque-Medium", size: 19)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: button.bounds.size.height / 2, bottom: 0, right: button.bounds.size.height / 2)
    }

    @IBAction func gotoEditarUsuario(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifEditUsuario"), object: nil)
    }

}
