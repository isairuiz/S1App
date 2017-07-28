//
//  CheckInsTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 13/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckInsTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaCercanos:[GeneralTableItem] = []
    var listaMisCheckIns:[GeneralTableItem] = []
    
    var fondoConfigurado: Bool = false
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var checkins : [JSON] = []
    var otrosCheckins : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("CERCANOS", derecha: "MIS CHECK IN")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        
        

    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(!fondoConfigurado){
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
            
            fondoConfigurado = true;
        }
        
        
        
    }
    
    
    // MARK: - Funciones y Eventos
    
    func cambiarPrimerTab (){
        self.listaCercanos.removeAll()
        self.obtenerCheckinsOtros()
    }
    
    func cambiarSegundoTab (){
        self.listaMisCheckIns.removeAll()
        self.obtenerMisCheckins()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1{
            return false
        }
        return true
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 66.0
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.tab
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        
        if self.tab.tabSeleccionada == 0 {
            if self.listaCercanos.isEmpty{
                if section == 1{
                    return 1
                }
                if section == 2{
                    return 0
                }
            }else{
                if section == 1{
                    return 0
                }
                return self.listaCercanos.count
            }
            
        }else if self.tab.tabSeleccionada == 1{
            if self.listaMisCheckIns.isEmpty{
                if section == 1{
                    return 1
                }
                if section == 2{
                    return 0
                }
            }else{
                if section == 1{
                    return 0
                }
            }
        }
        return self.listaMisCheckIns.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 92.0
        }
        
        return 108.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaCheckIn", for: indexPath)
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 3
            
            return cell
        }
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "celdaInfo", for: indexPath)
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as? CheckInTableViewCell
        
       
        
        var imagenURL:String = ""
        
        var item: GeneralTableItem?
        
        if self.tab.tabSeleccionada == 0 {
            
            item = self.listaCercanos[indexPath.row]
            
            cell?.badge.alpha = 1
            cell?.badge.text = item!.badge
            cell?.compartirFacebookButton.isHidden = true
            
            cell?.distancia.text = item!.ditancia
        } else{
            item = self.listaMisCheckIns[indexPath.row]
            
            cell?.badge.alpha = 0
            cell?.badge.text = "0"
            
            if item!.compartir {
                cell?.compartirFacebookButton.isHidden = false
            } else {
                cell?.compartirFacebookButton.isHidden = true
            }
            
            cell?.distancia.text = "\(item!.ditancia) · \(item!.tiempo)"
        }
        
        imagenURL = item!.avatar
        
        cell?.nombre.text = item!.nombre
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let lugar = NSMutableAttributedString(string: "\( item!.lugar): ", attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue-Bold", size: 12)!, NSForegroundColorAttributeName: ColoresTexto.Pink, NSParagraphStyleAttributeName: paragraphStyle ])
        
        let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSForegroundColorAttributeName: ColoresTexto.Pink, NSParagraphStyleAttributeName: paragraphStyle ])
        
        lugar.append(descripcion)
        cell?.texto.attributedText = lugar
        
        cell?.texto.lineBreakMode = .byTruncatingTail
        
        let imagen =  self.imagenCache[imagenURL];
        cell?.foto.image = nil
        
        if(imagen == nil){
            // Si la imagen no exite hay que descargarla
            if imagenURL != "" {
                let url:URL = URL(string: "\(imagenURL)" )!
                let session = URLSession.shared;
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = url;
                request.httpMethod = "GET"
                
                
                let task = session.dataTask(with: request as URLRequest){data,response, error in
                    
                    
                    guard data != nil else {
                        cell?.foto.image = nil
                        return
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let _imagen = UIImage(data: data!) {
                            
                            let imagen = Utilerias.aplicarEfectoDifuminacionImagen(_imagen, intensidad: item!.restriccion)
                            
                            self.imagenCache[imagenURL] = imagen;
                            
                            if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell {
                                
                                cell.foto.image = imagen
                                
                            }
                        } else {
                            if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell {
                                cell.foto.image = nil
                            }
                        }
                    })
                };
                task.resume()
            } else {
                cell?.foto.image = nil
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell  {
                    cell.foto.image = imagen
                }
            })
        }
        
        
        
        return cell!
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            DataUserDefaults.setControllsCheckin(type: 1)
        }
        if self.tab.tabSeleccionada == 0{
            if indexPath.section != 0{
                let jsonCheck:JSON = self.otrosCheckins[indexPath.row]
                if let id_singular = jsonCheck["id_singular"].int{
                    DataUserDefaults.setControllsCheckin(type: 4)
                }
                DataUserDefaults.setJsonCheckin(json: self.otrosCheckins[indexPath.row].description)
            }
        }else{
            if indexPath.section != 0{
                let jsonCheck:JSON = self.checkins[indexPath.row]
                if let id_singular = jsonCheck["id_singular"].int{
                    DataUserDefaults.setControllsCheckin(type: 3)
                }else{
                    DataUserDefaults.setControllsCheckin(type: 2)
                }
                DataUserDefaults.setJsonCheckin(json: self.checkins[indexPath.row].description)
            }
            
        }
        self.performSegue(withIdentifier: "MostrarHacerCheckIn", sender: self)
        
    }
    
    func obtenerCheckinsOtros(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.LISTAR_CHECKS_OTROS, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["checkins"].isEmpty{
                            self.otrosCheckins = json["checkins"].arrayValue
                            for checkin in self.otrosCheckins{
                                let id = checkin["id"].int
                                let id_singular = checkin["id_singular"].int
                                let nombre = checkin["nombre"].string
                                let edad = checkin["edad"].int
                                let imagen = checkin["imagen"].string
                                let foto_visible = checkin["foto_visible"].floatValue
                                let fecha = checkin["fecha"].string
                                let lat = checkin["latitud"].double
                                let long = checkin["longitud"].double
                                let distancia = checkin["distancia"].intValue
                                let titulo = checkin["titulo"].string
                                let contenido = checkin["contenido"].string
                                let cal = checkin["calificacion"].int
                                var urlFoto = Constantes.BASE_URL
                                urlFoto += imagen!
                                self.listaCercanos.append(
                                    GeneralTableItem(id: id!, nombre:nombre!, distancia: "\(distancia) Metros", tiempo: fecha!, lugar: titulo!, descripcion: contenido!, avatar: urlFoto, badge: "0", compartir: false, resaltar: false, restriccion: foto_visible)
                                )
                            }
                        }
                        self.tableView.reloadData()
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }else{
                        self.tableView.reloadData()
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }
                }
        }
    }
    func obtenerMisCheckins(){
        let fotoPerfilUrl = DataUserDefaults.getFotoPerfilUrl()
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.MIS_CHECKINS, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["checkins"]["singular"].isEmpty{
                            self.checkins = json["checkins"]["singular"].arrayValue
                            for checkin in self.checkins{
                                let idCheck  = checkin["id"].int
                                let fecha = checkin["fecha"].string
                                _ = checkin["latitud"].double
                                _ = checkin["longitud"].double
                                let titulo = checkin["titulo"].string
                                let contenido = checkin["contenido"].string
                                let cal = checkin["calificacion"].int
                                
                                self.listaMisCheckIns.append(
                                    GeneralTableItem(id: idCheck!, nombre:"Yo", distancia: "", tiempo: fecha!, lugar: titulo!, descripcion: contenido!, avatar: fotoPerfilUrl, badge: "0", compartir: false, resaltar: false, restriccion: 1.0)
                                )
                            }
                            self.tableView.reloadData()
                            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        }
                        if !json["checkins"]["amigos"].isEmpty{
                            let checkamigos:[JSON] = json["checkins"]["amigos"].arrayValue
                            for check in checkamigos{
                                self.checkins.append(check)
                                let id = check["id"].int
                                let id_singular = check["id_singular"].int
                                let nombre = check["nombre"].string
                                let edad = check["edad"].int
                                let image = check["imagen"].string
                                let foto_visible = check["foto_visible"].floatValue
                                debugPrint("wtf el blur: \(foto_visible)")
                                let fecha = check["fecha"].string
                                let lat = check["latitud"].double
                                let long = check["longitud"].double
                                let titulo = check["titulo"].string
                                let contenido = check["contenido"].string
                                let calif = check["calificacion"] != JSON.null && !check["calificacion"].isEmpty ? check["calificacion"].int : 0
                                var urlFoto = Constantes.BASE_URL
                                urlFoto += image!
                                self.listaMisCheckIns.append(
                                    GeneralTableItem(id: id!, nombre:nombre!, distancia: "", tiempo: fecha!, lugar: titulo!, descripcion: contenido!, avatar: urlFoto, badge: "0", compartir: false, resaltar: false, restriccion: foto_visible)
                                )
                            }
                        }
                        self.tableView.reloadData()
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }else{
                        self.tableView.reloadData()
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.tab.tabSeleccionada == 0{
            self.listaCercanos.removeAll()
            self.obtenerCheckinsOtros()
        }else{
            self.listaMisCheckIns.removeAll()
            self.obtenerMisCheckins()
        }
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
