//
//  HomeTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeTableViewController: UITableViewController {
    @IBOutlet weak var creditsButton: UIView!
    
    let loadingView = UIView()
    
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    var fotitos = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        self.creditsButton.layer.shadowColor = UIColor.black.cgColor
        self.creditsButton.layer.shadowOpacity = 0.5
        self.creditsButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.creditsButton.layer.shadowRadius = 3
        DataUserDefaults.setDefaultData()
        self.getUserData()
    }
    
    func getUserData(){
        self.setLoadingScreen()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer "+DataUserDefaults.getUserToken()
        ]
        
        Alamofire.request(Constantes.VER_MI_PERFIL_URL, headers: headers)
            .responseJSON {
            response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                if(status){
                    if let saldo = json["perfil"]["saldo"].int{
                        debugPrint("saldo:")
                        debugPrint(saldo)
                        DataUserDefaults.setSaldo(saldo: saldo)
                    }
                    if let nombre = json["perfil"]["nombre"].string{
                        debugPrint("nombre:")
                        debugPrint(nombre)
                        DataUserDefaults.saveDataNombre(nombre: nombre)
                    }
                    if let genero = json["perfil"]["genero"].int{
                        debugPrint("genero:")
                        debugPrint(genero)
                        DataUserDefaults.saveDataGenero(genero: genero)
                    }
                    if let edad = json["perfil"]["edad"].int{
                        debugPrint("edad:")
                        debugPrint(edad)
                        DataUserDefaults.saveDataEdad(edad: String(edad))
                    }
                    if let estado = json["perfil"]["estado"].int{
                        debugPrint("estado:")
                        debugPrint(estado)
                        DataUserDefaults.saveDataEstado(estado: estado)
                    }
                    if let prof = json["perfil"]["profesion"].string{
                        debugPrint("profesion:")
                        debugPrint(prof)
                        DataUserDefaults.saveDataProfesion(profesion: prof)
                    }
                    if let idFoto = json["perfil"]["id_fotografia_perfil"].int{
                        debugPrint("idFotoPerfil:")
                        debugPrint(idFoto)
                        DataUserDefaults.saveIdFotoPerfil(id: idFoto)
                        if !json["perfil"]["fotografias"].isEmpty{
                            self.fotitos = json["perfil"]["fotografias"].dictionaryObject as! Dictionary<String, String>
                            debugPrint(self.fotitos)
                            self.setPerfilFoto(idFotoPerfil: idFoto)
                        }else{
                            DataUserDefaults.setFotoPerfilUrl(url: "")
                        }
                    }
                    if let fumo = json["perfil"]["fumo"].bool{
                        debugPrint("fumo:")
                        debugPrint(fumo)
                        DataUserDefaults.saveDataFumo(fumo: fumo)
                    }
                    if let bgenero = json["perfil"]["que_busco"]["genero"].int{
                        debugPrint("Busco genero:")
                        debugPrint(bgenero)
                        DataUserDefaults.saveDataBuscoGenero(buscoGenero: bgenero)
                    }
                    if let bedadMinima = json["perfil"]["que_busco"]["edad_minima"].int{
                        debugPrint("Edad minima:")
                        debugPrint(bedadMinima)
                        DataUserDefaults.saveDataBuscoEdadMinima(edad: bedadMinima)
                    }
                    
                    if let bedadMaxima = json["perfil"]["que_busco"]["edad_maxima"].int{
                        debugPrint("Edad Maxima:")
                        debugPrint(bedadMaxima)
                        DataUserDefaults.saveDataBuscoEdadMaxima(edad: bedadMaxima)
                    }
                    if let bdistancia = json["perfil"]["que_busco"]["radio"].int{
                        debugPrint("distancia radio")
                        debugPrint(bdistancia)
                        DataUserDefaults.saveDataBuscoDistancia(distancia: bdistancia)
                    }
                    if let bfuma = json["perfil"]["que_busco"]["fuma"].int{
                        debugPrint("busco fuma:")
                        debugPrint(bfuma)
                        DataUserDefaults.saveDataBuscoFuma(buscoFuma: bfuma)
                    }
                    
                    
                    let estados: Array<JSON> = json["perfil"]["que_busco"]["estado"].arrayValue
                    if estados.count > 0{
                        debugPrint("Busco Estados civiles:")
                        debugPrint(estados)
                        for estado in estados{
                            if estado=="1"{
                                DataUserDefaults.saveBuscoSoltero(num: 1)
                            }
                            if estado=="2"{
                                DataUserDefaults.saveBuscoCasado(num: 1)
                            }
                            if estado=="3"{
                                DataUserDefaults.saveBuscoDivorciado(num: 1)
                            }
                            if estado=="4"{
                                DataUserDefaults.saveBuscoSeparado(num: 1)
                            }
                            if estado=="5"{
                                DataUserDefaults.saveBuscoUnionlibre(num: 1)
                            }
                            if estado=="6"{
                                DataUserDefaults.saveBuscoViudo(num: 1)
                            }
                        }
                    }
                    
                    let que_deseo: Array<JSON> = json["perfil"]["que_busco"]["que_deseo"].arrayValue
                    if que_deseo.count > 0{
                        debugPrint("Que deseo:")
                        debugPrint(que_deseo)
                        for deseo in que_deseo{
                            if deseo == "1"{
                                DataUserDefaults.saveDataBuscoAmistad(relacion: 1)
                            }
                            if deseo == "2"{
                                DataUserDefaults.saveDataBuscoCortoPlazo(relacion: 1)
                            }
                            if deseo == "3"{
                                DataUserDefaults.saveDataBuscoLargoPlazo(relacion: 1)
                            }
                            if deseo == "4"{
                                DataUserDefaults.saveDataBuscoSalir(relacion: 1)
                            }
                            
                        }
                    }
                    self.removeLoadingScreen()
                }else{
                    self.removeLoadingScreen()
                }
            }
            
        }
    }
    
    func setPerfilFoto(idFotoPerfil:Int){
        for (key,value):(String, String) in self.fotitos {
            if(key == String(idFotoPerfil)){
                var urlImage = Constantes.BASE_URL
                urlImage += value
                DataUserDefaults.setFotoPerfilUrl(url: urlImage)
            }
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
   

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 8.0;
        }
        
        return tableView.sectionHeaderHeight;
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
