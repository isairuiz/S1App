//
//  HacerCheckInTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class HacerCheckInTableViewController: UITableViewController,  CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var starsContentView: UIView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var hacerCheckInTableViewCell: UITableViewCell!
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    
    @IBOutlet weak var hacerCheckInViewButton: UIView!
    @IBOutlet weak var compartirCheckInViewButton: UIView!
    
    
    @IBOutlet weak var mapTableViewCell: UITableViewCell!
    @IBOutlet weak var dondeEstasTableViewCell: UITableViewCell!
    @IBOutlet weak var queHacesTableViewCell: UITableViewCell!
    @IBOutlet weak var verMiCheckinCell: UITableViewCell!
    @IBOutlet weak var verOtroCheckinCell: UITableViewCell!
    
    @IBOutlet weak var dondeEstasTextField: UITextField!
    @IBOutlet weak var queHacesTextField: UITextField!
    
    
    @IBOutlet weak var verCheckinLugar: UILabel!
    @IBOutlet weak var verCheckinFecha: UILabel!
    @IBOutlet weak var verCheckingContenido: UILabel!
    
    @IBOutlet weak var otroCheckinNombre: UILabel!
    @IBOutlet weak var otroCheckinFecha: UILabel!
    @IBOutlet weak var otroCheckinLugar: UILabel!
    @IBOutlet weak var otroCheckinContenido: UILabel!
    
    var calificacion:Int = 0
    var checkInRealizado:Bool = false
    
    var locationManager:CLLocationManager = CLLocationManager();
    var ubicacion: CLLocationCoordinate2D!;
    var ubicacionCentrada = false
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var showControllsFor : Int = DataUserDefaults.getControllsCheckin()
    
    let jsonCheckinString:String? = DataUserDefaults.getJsonCheckin()
    var jsonCheckin : JSON?

    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.starsContentView.layoutIfNeeded()
        self.starsContentView.layer.cornerRadius = self.starsContentView.bounds.height / 2
        
        
        let hacerCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.hacerCheckIn))
        self.hacerCheckInTableViewCell.addGestureRecognizer(hacerCheckInTap)
        
        let compartirCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirCheckInTap)
        
        self.hacerCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.hacerCheckInViewButton.layer.shadowOpacity = 0.5
        self.hacerCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.hacerCheckInViewButton.layer.shadowRadius = 3
        
        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
        
        
        
        
        
        
        self.dondeEstasTextField.delegate = self
        self.queHacesTextField.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        if let dataFromString = jsonCheckinString?.data(using: .utf8, allowLossyConversion: false){
            jsonCheckin = JSON(data: dataFromString)
            debugPrint(jsonCheckin)
        }
        
        if showControllsFor == 1{
            self.mapa.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            ubicacion = nil
            locationManager.startUpdatingLocation()
            
        }else if showControllsFor == 2{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changetitle"), object: nil, userInfo: ["windowType":2])
            _  = jsonCheckin?["id"].int
            let fecha = jsonCheckin?["fecha"].string
            let lat = jsonCheckin?["latitud"].double
            let long = jsonCheckin?["longitud"].double
            let titulo = jsonCheckin?["titulo"].string
            let contenido = jsonCheckin?["contenido"].string
            let cal = jsonCheckin?["calificacion"].int
            self.addCalificacion(calificacion:cal!)
            self.verCheckinLugar.text = titulo
            self.verCheckinFecha.text = fecha
            self.verCheckingContenido.text = contenido
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            self.mapa.setRegion(region, animated: true)
            self.starsContentView.isUserInteractionEnabled = false
            self.mapa.isUserInteractionEnabled = false
        }else if showControllsFor == 3 || showControllsFor == 4{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changetitle"), object: nil, userInfo: ["windowType":3])
            let nombre = jsonCheckin?["nombre"].string
            let edad = jsonCheckin?["edad"].int
            let fecha = jsonCheckin?["fecha"].string
            let lat = jsonCheckin?["latitud"].double
            let long = jsonCheckin?["longitud"].double
            let titulo = jsonCheckin?["titulo"].string
            let contenido = jsonCheckin?["contenido"].string
            //let cal = jsonCheckin?["calificacion"] != JSON.null && !(jsonCheckin?["calificacion"].isEmpty)! ? jsonCheckin?["calificacion"].int : 0
            let cal = jsonCheckin?["calificacion"].int
            var nombreEdad : String = nombre!
            nombreEdad += " - \(edad!) años"
            self.otroCheckinNombre.text = nombreEdad
            self.otroCheckinFecha.text = fecha
            self.otroCheckinLugar.text = titulo
            self.otroCheckinContenido.text = contenido
            self.addCalificacion(calificacion:cal!)
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            self.mapa.setRegion(region, animated: true)
            self.starsContentView.isUserInteractionEnabled = false
            self.mapa.isUserInteractionEnabled = false
        }
        
    }
    
    func disableStars(){
        /*self.star1.isEnabled = false
        self.star2.isEnabled = false
        self.star3.isEnabled = false
        self.star4.isEnabled = false
        self.star5.isEnabled = false*/
        
    }

    // MARK: - Eventos y acciones
    
    @IBAction func star1Presionada(_ sender: AnyObject) {
        
        self.calificacion = 1
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star2Presionada(_ sender: AnyObject) {
        
        self.calificacion = 2
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star3Presionada(_ sender: AnyObject) {
        
        self.calificacion = 3
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star4Presionada(_ sender: AnyObject) {
        
        self.calificacion = 4
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star5Presionada(_ sender: AnyObject) {
        
        self.calificacion = 5
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        
    }
    
    func addCalificacion(calificacion:Int){
        
        if calificacion == 1{
            self.calificacion = 1
            self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star2.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        }else if calificacion == 2{
            self.calificacion = 2
            self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        }else if calificacion == 3{
            self.calificacion = 3
            self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
            self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        }else if calificacion == 4{
            self.calificacion = 4
            self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        }else if calificacion == 5{
            self.calificacion = 5
            self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
            self.star5.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        }
    }
    
    func hacerCheckIn(){
        let loadingView = UIView()
        let loadinLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        
        let titulo:String = self.dondeEstasTextField.text!
        let contenido:String = self.queHacesTextField.text!
        
        if titulo.isEmpty || contenido.isEmpty{
            self.showAlertWithMessage(title: "Error", message: "Escribe el lugar donde te encuentras y que haces, para que tus S1ngulares lo sepan.")
        }else{
            Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadinLabel, spinner: spinner)
            let parameters: Parameters = [
                "latitud": self.ubicacion.latitude,
                "longitud": self.ubicacion.longitude,
                "titulo": titulo,
                "contenido": contenido,
                "calificacion": self.calificacion
            ]
            
            Alamofire.request(Constantes.AGREGAR_CHECKIN, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    let json = JSON(response.result.value)
                    debugPrint(json)
                    if let status = json["status"].bool{
                        if status{
                            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadinLabel, spinner: spinner)
                            self.checkInRealizado = true
                            if let mensaje = json["mensaje_plain"].string{
                                self.showAlertWithMessage(title: "Muy bien!", message: mensaje)
                            }
                            self.dondeEstasTextField.text = ""
                            self.queHacesTextField.text = ""
                        }else{
                            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadinLabel, spinner: spinner)
                            if let mensaje = json["mensaje_plain"].string{
                                self.showAlertWithMessage(title: "Error!", message: mensaje)
                            }
                        }
                    }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func compartirCheckIn(){
        
        print("compartir")
        
    }
    
    func showAlertWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: {
            action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goback"), object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -  Table
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 3 || indexPath.row == 4 {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        // Logo
        if indexPath.row == 0 {
            return 200
        }
        // Slogan y delimitador "o"
        
        
        
        // Mostrar controles para hacer checkin
        if self.showControllsFor == 1{
            if indexPath.row == 1 || indexPath.row == 2 {
                return 66
            }
            if indexPath.row == 3 || indexPath.row == 4{
                return 0
            }
            if !self.checkInRealizado && indexPath.row == 5 {
                return 78
            }
            
            if self.checkInRealizado && indexPath.row == 6 {
                return 78
            }
        // Mostrar controles para ver mi checkin
        }else if self.showControllsFor == 2{
            if indexPath.row == 3{
                return 150
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5{
                return 0
            }
            if indexPath.row == 6 {
                return 78
            }
        // Mostrar controles para ver otro checkin
        }else if self.showControllsFor == 3{
            if indexPath.row == 4{
                return 150
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6{
                return 0
            }
            
        }
        
        return 0
        
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.ubicacion = mapView.centerCoordinate
        debugPrint("Ubicacion actual: \(self.ubicacion)")
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        if self.showControllsFor == 1{
            self.ubicacion = manager.location!.coordinate
            if !ubicacionCentrada {
                let center = CLLocationCoordinate2D(latitude: self.ubicacion.latitude, longitude: self.ubicacion.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                
                self.mapa.setRegion(region, animated: true)
                ubicacionCentrada = true
            }
        }else{
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        let alert = UIAlertController(title: "Error", message: "No se pudo cargar tu ubicación", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.cancel, handler:nil)
        alert.addAction(okAction)
        self.ubicacion = nil;
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.dondeEstasTextField {
            self.queHacesTextField.becomeFirstResponder()
        }
        
        if textField == self.queHacesTextField {
            
            self.view.endEditing(true)
            
        }
        
        return true
    }
    
    // MARK: - Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }



}
