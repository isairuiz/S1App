//
//  EditarMiPerfilTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 04/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditarMiPerfilTableViewController: UITableViewController {


    @IBOutlet weak var floatingView: UIVisualEffectView!
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var escribeSobreTiButton: UIButton!
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var profesion: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var descripcionUsuario: UITextView!
    
    var tapViewImage = UIGestureRecognizer()
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var fotitos = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingView.backgroundColor = Colores.MainKAlpha
        transformButton(button: self.escribeSobreTiButton)
        
        tapViewImage = UITapGestureRecognizer(target: self, action: #selector(self.gotoMisFotos(sender:)))
        tapViewImage.cancelsTouchesInView = false
        fotoPerfil.addGestureRecognizer(tapViewImage)
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 300
        }else if indexPath.row == 1{
            return UITableViewAutomaticDimension
        }else {
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func gotoMisFotos(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifMisFotos"), object: nil)
    }
    
    func fillWindow(){
        
        
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        
        Alamofire.request(Constantes.VER_MI_PERFIL_URL, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if let nombre = json["perfil"]["nombre"].string{
                            if nombre != ""{
                                DataUserDefaults.saveDataNombre(nombre: nombre)
                                self.nombreUsuario.text = nombre
                            }else{
                                self.nombreUsuario.text = "Configura tu nombre de usuario"
                            }
                            
                        }
                        if let prof = json["perfil"]["profesion"].string{
                            if prof != ""{
                                self.profesion.text = prof
                                DataUserDefaults.saveDataProfesion(profesion: prof)
                            }else{
                                self.profesion.text = "Configura tu profesion"
                            }
                            
                        }
                        if let descripcion = json["perfil"]["sobre_mi"].string{
                            if !descripcion.isEmpty{
                                self.descripcionUsuario.text = descripcion
                                DataUserDefaults.saveDataSobreMi(sobreti: descripcion)
                            }else{
                                self.descripcionUsuario.text = "Aún no has escrito sobre ti."
                            }
                        }
                        if let idFoto = json["perfil"]["id_fotografia_perfil"].int{
                            if idFoto > 0{
                                DataUserDefaults.saveIdFotoPerfil(id: idFoto)
                                if !json["perfil"]["fotografias"].isEmpty{
                                    self.fotitos = json["perfil"]["fotografias"].dictionaryObject as! Dictionary<String, String>
                                    let fotoo:String = self.getUrlPerfilFoto(idFotoPerfil: idFoto)
                                    self.fotoPerfil.downloadedFrom(link: fotoo,withBlur:false,maxBlur:1.0)
                                }else{
                                    DataUserDefaults.setFotoPerfilUrl(url: "")
                                }
                            }else{
                                self.info.isHidden = false
                            }
                            
                        }
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }
                }
        }
    }
    
    func getUrlPerfilFoto(idFotoPerfil:Int) -> String{
        for (key,value):(String, String) in self.fotitos {
            if(key == String(idFotoPerfil)){
                var urlImage = Constantes.BASE_URL
                urlImage += value
                return urlImage
            }
        }
        return ""
    }
    override func viewDidAppear(_ animated: Bool) {
        self.fotitos.removeAll()
        self.fillWindow()
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
