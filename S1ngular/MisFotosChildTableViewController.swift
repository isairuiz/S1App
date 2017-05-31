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
    
    var listaFotos:[String] = []
    let reuseIdentifier = "fotoCell"
    var fotitos = Dictionary<String, String>()
    var idFotoPerfil = Int()
    var baseUrl = String()
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    @IBOutlet weak var collectionFotosCell: UITableViewCell!
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var inforMessage: UILabel!
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        self.setLoadingScreen()
        self.getUserData()
        self.idFotoPerfil = DataUserDefaults.getidFotoPerfil()
        self.baseUrl = Constantes.BASE_URL
        
        
    }
    
    func getUserData(){
        
        
        Alamofire.request(Constantes.VER_MI_PERFIL_URL, headers: self.headers)
            .validate(contentType: ["application/json"])
            .responseJSON {
                response in
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
                            }
                        }else{
                            self.inforMessage.isHidden = false
                            debugPrint("No hay fotos...")
                        }
                        
                        
                    }else{
                        
                    }
                }
                self.removeLoadingScreen()
                
        }
    }
    
    func setPerfilFoto(){
        for (key,value):(String, String) in self.fotitos {
            var urlImage = baseUrl
            urlImage += value
            if(key == String(idFotoPerfil)){
                self.fotoPerfil.downloadedFrom(link: urlImage)
            }
        }
    }
    
    func cambiarIdFotoPerfil(idFoto: String){
        self.setLoadingScreen()
        let params: Parameters = [
            "id_fotografia": idFoto,
        ]
        
        Alamofire.request(Constantes.DEF_FOTO_PERFIL_URL, method: .post, parameters:params, encoding: URLEncoding.httpBody,headers:self.headers)
            .responseJSON{response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if var message = json["mensaje_plain"].string{
                            self.getUserData()
                        }
                    }else{
                        if var message = json["mensaje_plain"].string{
                            self.showAlerWithMessage(title: "¡Error!",message: message )
                        }
                    }
                }
                
        }

    }
    
    func showAlerWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func setLoadingScreen() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 140
        let height: CGFloat = 50
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x:x, y:y, width:width, height:height)
        loadingView.clipsToBounds = true
        loadingView.backgroundColor = Colores.BGPink
        
        // Sets loading text
        self.loadingLabel.textColor = Colores.BGWhite
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Cargando..."
        self.loadingLabel.frame = CGRect(x:0+15, y:0+5, width:150, height:30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.spinner.frame = CGRect(x:0, y:0, width:50, height:50)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        UIApplication.shared.endIgnoringInteractionEvents()
        // Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        self.loadingView.isHidden = true
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 260.0
        }else{
            return 360.0
        }
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
            cell.foto.downloadedFrom(link: urlImage)
            return cell
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyFoto   = Array(self.fotitos.keys)[indexPath.row]
        let urlFoto = Array(self.fotitos.values)[indexPath.row]
        if(keyFoto != String(self.idFotoPerfil)){
            let alert = UIAlertController(title: "¿Desea continuar?", message: "Se usara esta foto como foto de perfil.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
                self.cambiarIdFotoPerfil(idFoto: keyFoto)
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
