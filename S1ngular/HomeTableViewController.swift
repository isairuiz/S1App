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
import CoreLocation

class HomeTableViewController: UITableViewController,CLLocationManagerDelegate {
    @IBOutlet weak var creditsButton: UIView!
    
    
    
    var fotitos = Dictionary<String, String>()
    
    @IBOutlet weak var nuevosSingulares: UILabel!
    @IBOutlet weak var nuevosMensajes: UILabel!
    @IBOutlet weak var nuevosCheckins: UILabel!
    @IBOutlet weak var nuevosTests: UILabel!
    
    @IBOutlet weak var gotoS1Cell: UITableViewCell!
    @IBOutlet weak var gotoMensajesCell: UITableViewCell!
    @IBOutlet weak var gotoMisResultadosCell: UITableViewCell!
    @IBOutlet weak var gotoNuevosTestsCell: UITableViewCell!
    @IBOutlet weak var gotoCheckinsCell: UITableViewCell!
    
    @IBOutlet weak var misaldo: UILabel!
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var locationManager:CLLocationManager = CLLocationManager();
    var ubicacion: CLLocationCoordinate2D!;
    
    var locationHasSet:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        self.creditsButton.layer.shadowColor = UIColor.black.cgColor
        self.creditsButton.layer.shadowOpacity = 0.5
        self.creditsButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.creditsButton.layer.shadowRadius = 3
        DataUserDefaults.setDefaultData()

        
        let tapViewS1 = UITapGestureRecognizer(target: self, action: #selector(self.gotoS1(sender:)))
        let tapViewMensajes = UITapGestureRecognizer(target: self, action: #selector(self.gotoMensajes(sender:)))
        let tapViewResultados = UITapGestureRecognizer(target: self, action: #selector(self.gotoResultados(sender:)))
        let tapViewNuevosTests = UITapGestureRecognizer(target: self, action: #selector(self.gotoNuevosTests(sender:)))
        let tapViewCheckins = UITapGestureRecognizer(target: self, action: #selector(self.gotoCheckins(sender:)))
        
        self.gotoS1Cell.addGestureRecognizer(tapViewS1)
        self.gotoMensajesCell.addGestureRecognizer(tapViewMensajes)
        self.gotoMisResultadosCell.addGestureRecognizer(tapViewResultados)
        self.gotoNuevosTestsCell.addGestureRecognizer(tapViewNuevosTests)
        self.gotoCheckinsCell.addGestureRecognizer(tapViewCheckins)
    }
    
    func gotoS1(sender: UITapGestureRecognizer){
        //DataUserDefaults.setFromTabS1Nuevos(isit: true)
        tabBarController?.selectedIndex = 1
        
    }
    func gotoMensajes(sender: UITapGestureRecognizer){
        //DataUserDefaults.setFromTabS1Nuevos(isit: false)
        tabBarController?.selectedIndex = 1
    }
    func gotoResultados(sender: UITapGestureRecognizer){
        //DataUserDefaults.setFromTabTestResult(isit: true)
        tabBarController?.selectedIndex = 2
    }
    func gotoNuevosTests(sender: UITapGestureRecognizer){
        //DataUserDefaults.setFromTabTestResult(isit: false)
        tabBarController?.selectedIndex = 2
    }
    func gotoCheckins(sender: UITapGestureRecognizer){
        tabBarController?.selectedIndex = 3
    }
    
    func getUserData(){
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
                    if let saldo = json["perfil"]["saldo"].int{
                        debugPrint("saldo:")
                        debugPrint(saldo)
                        DataUserDefaults.setSaldo(saldo: saldo)
                        self.misaldo.text = "\(saldo) S1NGLE CREDITS"
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
                    /******************//******************//******************/
                    /*Cambiar esto por el codigo que obtendra el ID de usuario*/
                    DataUserDefaults.setCurrentId(id: 17)
                    /******************//******************//******************/
                    
                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                }else{
                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                }
            }
            
        }
    }
    
    func visitarHome(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.VISITAR_HOME_URL, headers: self.headers)
            .responseJSON {
                response in
                
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if let s1Nuevos = json["home"]["singulares_nuevos"].int{
                            if s1Nuevos>1{
                                self.nuevosSingulares.text = "¡\(s1Nuevos) NUEVOS S1!"
                            }else{
                                self.nuevosSingulares.text = "¡\(s1Nuevos) NUEVO S1!"
                            }
                            
                        }
                        if let mensajesNuevos = json["home"]["mensajes_nuevos"].int{
                            if mensajesNuevos>1{
                                self.nuevosMensajes.text = "¡\(mensajesNuevos) MENSAJES NUEVOS!"
                            }else{
                                self.nuevosMensajes.text = "¡\(mensajesNuevos) MENSAJE NUEVO!"
                            }
                            
                        }
                        if let testsNuevos = json["home"]["nuevos_test"].int{
                            self.nuevosTests.text = "¡\(testsNuevos) NUEVOS TESTS!"
                        }
                        if let checkinsNuevos = json["home"]["chekins_cercanos"].int{
                            self.nuevosCheckins.text = "¡\(checkinsNuevos) S1NGULARES A TU ALREDEDOR!"
                        }
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }
                }
        }
    }
    
    func actualizarPosicion(latitud:Double,longitud:Double){
        let parameters: Parameters = ["latitud": latitud,"longitud":longitud]
        Alamofire.request(Constantes.ACTUALIZAR_POSICION, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        
                    }else{
                        if let errorMessage = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error", message: errorMessage)
                        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getUserData()
        self.visitarHome()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        ubicacion = nil
        locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        if !self.locationHasSet{
            debugPrint("ubicacion obtenida =)")
            self.ubicacion = manager.location!.coordinate
            self.actualizarPosicion(latitud: self.ubicacion.latitude, longitud: self.ubicacion.longitude)
            self.locationHasSet = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        debugPrint("ubicacion no pudo ser obtenida =(")
        self.showAlertWithMessage(title:"Error",message: "No se pudo obtener tu ubicación")
        self.ubicacion = nil;
    }
    
    
    func showAlertWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
