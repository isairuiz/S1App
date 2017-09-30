//
//  MisFotosChildTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 22/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MisFotosChildTableViewController: UITableViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "fotoCell"
    var fotitos = Dictionary<String, String>()
    var idFotoPerfil = Int()
    var baseUrl = String()


    @IBOutlet weak var collectionFotosCell: UITableViewCell!
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var inforMessage: UILabel!
    @IBOutlet weak var subirFotoCell: UITableViewCell!
    @IBOutlet weak var subirFotoButton: UIView!
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        self.idFotoPerfil = DataUserDefaults.getidFotoPerfil()
        self.baseUrl = Constantes.BASE_URL
        
        
        subirFotoButton.layer.shadowColor = UIColor.black.cgColor
        subirFotoButton.layer.shadowOpacity = 0.5
        subirFotoButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        subirFotoButton.layer.shadowRadius = 3
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.subirFotoTap(_:)))
        self.subirFotoCell.addGestureRecognizer(tapView)
        
    }
    
    func subirFotoTap(_ sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoSubirFoto"), object: nil)
    }
    
    
    func getUserData(){
        if Utilerias.isConnectedToNetwork(){
            let view = UIView()
            let label = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: view, tableView: self.tableView, loadingLabel: label, spinner: spinner)
            
            AFManager.request(Constantes.VER_MI_PERFIL_URL, headers: self.headers)
                .validate(contentType: ["application/json"])
                .responseJSON {
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if(status){
                                debugPrint("..........,....................................................")
                                if !json["perfil"]["fotografias"].isEmpty{
                                    self.fotitos = json["perfil"]["fotografias"].dictionaryObject as! Dictionary<String, String>
                                    debugPrint(self.fotitos)
                                    if !self.fotitos.isEmpty{
                                        self.setPerfilFoto()
                                        self.myCollection.reloadData()
                                        self.tableView.reloadData()
                                    }
                                    
                                }else{
                                    self.inforMessage.isHidden = false
                                    debugPrint("No hay fotos...")
                                }
                                Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
                            }else{
                                Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
                            }
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            self.alertWithMessage(title: "Error", message: "El servidor esta fuera de linea, por favor intenta mas tarde.")
                            debugPrint("timeOut")
                        }else{
                            self.alertWithMessage(title:"Error",message:"El servidor encontro un error, por favor intenta mas tarde.")
                        }
                        break
                    }
                    
                    
            }
        }else{
            self.alertWithMessage(title: "Error", message: "No estas conectado, revisa tu conexión a internet.")
        }
    }
    
    func setPerfilFoto(){
        for (key,value):(String, String) in self.fotitos {
            var urlImage = baseUrl
            urlImage += value
            if(key == String(idFotoPerfil)){
                self.fotoPerfil.downloadedFrom(link: urlImage,withBlur:false,maxBlur:0)
            }
        }
    }
    
    func cambiarIdFotoPerfil(idFoto: String){
        if Utilerias.isConnectedToNetwork(){
            let view = UIView()
            let label = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: view, tableView: self.tableView, loadingLabel: label, spinner: spinner)
            let params: Parameters = [
                "id_fotografia": idFoto,
                ]
            
            AFManager.request(Constantes.DEF_FOTO_PERFIL_URL, method: .post, parameters:params, encoding: URLEncoding.httpBody,headers:self.headers)
                .responseJSON{response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
                            if(status){
                                self.getUserData()
                                
                            }else{
                                if var message = json["mensaje_plain"].string{
                                    self.alertWithMessage(title: "¡Error!",message: message )
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            self.alertWithMessage(title: "Error", message: "El servidor esta fuera de linea, por favor intenta mas tarde.")
                            debugPrint("timeOut")
                        }else{
                            self.alertWithMessage(title:"Error",message:"El servidor encontro un error, por favor intenta mas tarde.")
                        }
                        break
                    }
                    
                    
            }
        }else{
            self.alertWithMessage(title: "Error", message: "No estas conectado, revisa tu conexión a internet.")
        }
    }
    
    func eliminarFotografia(idFoto:Int){
        if Utilerias.isConnectedToNetwork(){
            let lView = UIView()
            let lLabel = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
            let parameters: Parameters = ["id_fotografia": idFoto]
            AFManager.request(Constantes.ELIMINAR_FOTO, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                            if status{
                                let mensaje = json["mensaje_plain"].string
                                self.alertWithMessage(title: "Bien!", message: mensaje!)
                                self.getUserData()
                            }else{
                                if let errorMessage = json["mensaje_plain"].string{
                                    self.alertWithMessage(title: "Error", message: errorMessage)
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            self.alertWithMessage(title: "Error", message: "El servidor esta fuera de linea, por favor intenta mas tarde.")
                            debugPrint("timeOut")
                        }else{
                            self.alertWithMessage(title:"Error",message:"El servidor encontro un error, por favor intenta mas tarde.")
                        }
                        break
                    }
            }
        }else{
            self.alertWithMessage(title: "Error", message: "No estas conectado, revisa tu conexión a internet.")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fotitos.removeAll()
        self.getUserData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.fotitos.keys.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            if indexPath.row == 0{
                return 78
            }
            if indexPath.row == 2{
                return 350
            }
            return 260.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FotosCollectionViewCell
        
        if !self.fotitos.isEmpty{
            let keyFoto   = Array(self.fotitos.keys)[indexPath.row]
            let urlFoto = Array(self.fotitos.values)[indexPath.row]
            var urlImage = baseUrl
            urlImage += urlFoto
            if(keyFoto != String(self.idFotoPerfil)){
                cell.definirFotoPerfil.isHidden = true
            }else{
                cell.definirFotoPerfil.isHidden = false
            }
            cell.foto.downloadedFrom(link: urlImage,withBlur:false,maxBlur:0)
            return cell
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyFoto   = Array(self.fotitos.keys)[indexPath.row]
        _ = Array(self.fotitos.values)[indexPath.row]
        if(keyFoto != String(self.idFotoPerfil)){
            
            
            let alert = UIAlertController(title: "Selecciona una acción", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "Usar como foto de perfil", style: UIAlertActionStyle.default, handler: { action in
                
                self.confirmAlert(keyFoto: keyFoto,changeFotoPerfil: true)
            }))
            alert.addAction(UIAlertAction(title: "Eliminar foto", style: UIAlertActionStyle.default, handler: {action in
                self.confirmAlert(keyFoto: keyFoto,changeFotoPerfil: false)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func confirmAlert(keyFoto:String,changeFotoPerfil:Bool){
        
        if changeFotoPerfil{
            let alert = UIAlertController(title: "¿Desea continuar?", message: "Se usara esta foto como foto de perfil.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Si, cambiar", style: UIAlertActionStyle.default, handler: { action in
                self.cambiarIdFotoPerfil(idFoto: keyFoto)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "¿Desea continuar?", message: "La foto sera eliminada de s1ngular", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Si, eliminar", style: UIAlertActionStyle.default, handler: { action in
                
                self.eliminarFotografia(idFoto: Int(keyFoto)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 01
        layout.minimumLineSpacing = 01
        layout.invalidateLayout()
        
        return CGSize(width: ((self.collectionFotosCell.frame.width/2) - 2), height:((self.collectionFotosCell.frame.width / 2) - 2));
        
        
    }
    


}
