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
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import MZFormSheetPresentationController

class HomeTableViewController: UITableViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
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
        
        let app = UIApplication.shared
        
        self.initializeFCM(app)
        let token = InstanceID.instanceID().token()
        if !(token?.isEmpty)!{
            debugPrint("GCM TOKEN FIREBASE= \(token!)")
            self.registrarFirebaseToken(token:token!)
        }else{
            debugPrint("Token vacion =(")
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkPushNotification), name: NSNotification.Name(rawValue: "enterForeground"), object: nil)
        
        checkPushNotification()
    }
    func checkPushNotification(){
        var pushType:String? = "0"
        if DataUserDefaults.getPushType() != nil{
            pushType = DataUserDefaults.getPushType()
            debugPrint("No hay push type")
        }
        if pushType == "0"{
            
        }else if pushType == "1"{
            /*Llevar al listado de s1ngulares*/
            DataUserDefaults.setTab(tab: 2)
            //tabBarController?.selectedIndex = 1
            
            
        }else if pushType == "2"{
            /*Llevar a interfaz S1 "El inicio de tu gran historia"*/
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoNuevoS1"), object: nil)
            tabBarController?.selectedIndex = 1
            //DataUserDefaults.setPushType(type: "0")
        }else if pushType == "3"{
            /*LLevar a interfaz de chat*/
            tabBarController?.selectedIndex = 1
            
        }
    }
    
    
    func gotoS1(sender: UITapGestureRecognizer){
        DataUserDefaults.setTab(tab: 2)
        tabBarController?.selectedIndex = 1
    }
    func gotoMensajes(sender: UITapGestureRecognizer){
        DataUserDefaults.setTab(tab: 1)
        tabBarController?.selectedIndex = 1
    }
    func gotoResultados(sender: UITapGestureRecognizer){
        DataUserDefaults.setTab(tab: 2)
        tabBarController?.selectedIndex = 2
    }
    func gotoNuevosTests(sender: UITapGestureRecognizer){
        DataUserDefaults.setTab(tab: 1)
        tabBarController?.selectedIndex = 2
    }
    func gotoCheckins(sender: UITapGestureRecognizer){
        DataUserDefaults.setTab(tab: 1)
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
                            self.nuevosSingulares.text = "¡\(s1Nuevos) NUEVOS S1!"
                            
                        }
                        if let mensajesNuevos = json["home"]["mensajes_nuevos"].int{
                            self.nuevosMensajes.text = "¡\(mensajesNuevos) MENSAJES NUEVOS!"
                            
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
    
    func initializeFCM(_ application: UIApplication){
        if #available(iOS 10.0, *) // enable new way for notifications on iOS 10
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (accepted, error) in
                if !accepted
                {
                    print("Notification access denied.")
                }
                else
                {
                    print("Notification access accepted.")
                    application.registerForRemoteNotifications()
                }
            }
        }else
        {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
    }
    
    func registrarFirebaseToken(token:String){
        let lView = UIView()
        let lLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
        let parameters: Parameters = ["idfirebase": token]
        Alamofire.request(Constantes.REG_FIREBASE_TOKEN, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let errorMessage = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "¡Algo va mal!", message: errorMessage)
                        }
                    }
                }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let json = JSON(notification.request.content.userInfo)
        debugPrint(json)
        var mensajeTipo:String = "0"
        var mensajeTitulo:String = ""
        var mensajeCuerpo:String = ""
        var mensajeUrl:String = ""
        var mensajeNombre:String = ""
        var mensajeMensaje:String = ""
        var fotoVisible:Float? = 0.0
        var mensajeRemitente = ""
        if let tipo = json["tipo"].string{
            mensajeTipo = tipo
        }
        if let titulo = json["titulo"].string{
            mensajeTitulo = titulo
        }
        if let cuerpo = json["cuerpo"].string{
            mensajeCuerpo = cuerpo
        }
        if let url = json["imagen"].string{
            mensajeUrl = url
            DataUserDefaults.setImagenS1(url: url)
        }
        if let nombre = json["nombre"].string{
            mensajeNombre = nombre
        }
        if let mensaje = json["mensaje"].string{
            mensajeMensaje = mensaje
        }
        if let idRemitente = json["id"].string{
            mensajeRemitente = idRemitente
        }
        
        fotoVisible = json["foto_visible"].float
        if mensajeTipo == "3"{
            if let topController = UIApplication.topViewController() {
                if topController is ChatS1ViewController{
                    let messageData:[String: String] = [
                        "mensaje": mensajeMensaje
                    ]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paintMessage"), object: nil, userInfo: messageData)
                    return
                }
            }
        }
        
        
        self.showNotification(tipo: mensajeTipo, titulo: mensajeTitulo, cuerpo: mensajeCuerpo, urlImagen: mensajeUrl, nombrePerfil: mensajeNombre,fotoVisible: fotoVisible)
        //completionHandler([.alert, .badge, .sound])
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
    
    
    func showNotification(tipo:String,titulo:String,cuerpo:String,urlImagen:String,nombrePerfil:String, fotoVisible:Float?) {
        var heightPercent:CGFloat = 0.70
        if tipo != "2"{
            heightPercent = 0.50
        }
        let maxWidth = UIScreen.main.bounds.width * 0.90
        let maxHeight = UIScreen.main.bounds.height * heightPercent
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationAlert") as! NotificationAlert
        viewController.tituloNotif = titulo
        viewController.tipoNotif = tipo
        viewController.cuerpoNotif = cuerpo
        viewController.urlNotif = urlImagen
        viewController.visible = fotoVisible
        viewController.nombreNotif = nombrePerfil
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: viewController)
        formSheetController.presentationController?.contentViewSize = CGSize(width: maxWidth, height: maxHeight)
        formSheetController.presentationController?.isTransparentTouchEnabled = false
        self.present(formSheetController, animated: true, completion: nil)
    }

}
