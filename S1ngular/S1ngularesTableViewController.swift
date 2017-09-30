//
//  S1ngularesTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class S1ngularesTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaChat:[GeneralTableItem] = []
    var listaNuevos:[GeneralTableItem] = []
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    var prospectos : [JSON] = []
    var mischats : [JSON] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("CHAT", derecha: "NUEVOS")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(pushS1ViewController), name: NSNotification.Name(rawValue: "gotoNuevoS1"), object: nil)
        

    }
    
    func pushS1ViewController(){
        self.performSegue(withIdentifier: "gotoYeah", sender: nil)
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
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 || indexPath.section == 2{
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2{
            return 0
        }
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tab.tabSeleccionada == 0 {
            if !self.listaChat.isEmpty{
                if indexPath.section == 1 || indexPath.section == 2{
                    return 0
                }
            }
            return 140
        }else{
            if !self.listaNuevos.isEmpty{
                if indexPath.section == 1 || indexPath.section == 2{
                    return 0
                }
            }
        }
        return 108
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return self.tab
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.tab.tabSeleccionada == 0 {
            if self.listaChat.isEmpty{
                if section == 1 {
                    return 1
                }
                if section == 2{
                    return 0
                }
            }else{
                if section == 1 || section == 2{
                    return 0
                }
                return self.listaChat.count
            }
        }else{
            if self.listaNuevos.isEmpty{
                if section == 1 {
                    return 0
                }
                if section == 2{
                    return 1
                }
            }else{
                if section == 1 || section == 2{
                    return 0
                }
            }
        }
        
        return self.listaNuevos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCellChats", for: indexPath)
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCellSingulares", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as? S1ngularesTableViewCell
        
        // Configure the cell...
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        var imagenURL:String = ""
        
        var item: GeneralTableItem?
        
        if self.tab.tabSeleccionada == 0 {
            if !self.listaChat.isEmpty{
                item = self.listaChat[(indexPath as NSIndexPath).row]
                
                cell?.badge.alpha = 1
                cell?.badge.text = item!.badge
                
                
                cell?.distancia.text = item!.ditancia
                if item!.resaltar {
                    cell?.actualizarTipo(3)
                } else {
                    if item!.badge == ""  {
                        cell?.actualizarTipo(2)
                    } else {
                        cell?.actualizarTipo(1)
                    }
                    
                }
                
                if !(item?.avatar.isEmpty)!{
                    imagenURL = item!.avatar
                }
                
                cell?.nombre.text = item!.nombre
                
                
                let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
                cell?.texto.attributedText = descripcion
                cell?.texto.lineBreakMode = .byTruncatingTail
                
                let imagen =  self.imagenCache[imagenURL];
                cell?.foto.image = UIImage(named: "Avatar")
                
                if(imagen == nil){
                    // Si la imagen no exite hay que descargarla
                    if item?.avatar != "" {
                        let url:URL = URL(string: "\(item!.avatar)?\( arc4random_uniform(100) )" )!
                        let session = URLSession.shared;
                        let request : NSMutableURLRequest = NSMutableURLRequest()
                        request.url = url;
                        request.httpMethod = "GET"
                        
                        
                        let task = session.dataTask(with: request as URLRequest){data,response, error in
                            
                            guard data != nil else {
                                cell?.foto.image = UIImage(named: "Avatar")
                                return
                                
                            }
                            
                            
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if let _imagen = UIImage(data: data!) {
                                    let imagen = Utilerias.aplicarEfectoDifuminacionImagen(_imagen, intensidad: item!.restriccion)
                                    self.imagenCache[imagenURL] = imagen;
                                    if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                        cell.foto.image = imagen
                                        
                                    }
                                } else {
                                    if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                        cell.foto.image = UIImage(named: "Avatar")
                                        
                                    }
                                }
                            })
                        };
                        task.resume()
                    } else {
                        cell?.foto.image = UIImage(named: "Avatar")
                        
                    }
                    
                    
                }else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                            cell.foto.image = imagen
                            
                        }
                        
                        
                    })
                }
            }
            
        } else{
            if !self.listaNuevos.isEmpty{
                item = self.listaNuevos[(indexPath as NSIndexPath).row]
                
                cell?.badge.alpha = 0
                cell?.badge.text = "0"
                cell?.distancia.text = ""
                
                cell?.actualizarTipo(2)
                
                if !(item?.avatar.isEmpty)!{
                    imagenURL = item!.avatar
                }
                
                cell?.nombre.text = item!.nombre
                
                
                let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
                cell?.texto.attributedText = descripcion
                cell?.texto.lineBreakMode = .byTruncatingTail
                
                let imagen =  self.imagenCache[imagenURL];
                cell?.foto.image = UIImage(named: "Avatar")
                
                if(imagen == nil){
                    // Si la imagen no exite hay que descargarla
                    if item?.avatar != "" {
                        let url:URL = URL(string: "\(item!.avatar)?\( arc4random_uniform(100) )" )!
                        let session = URLSession.shared;
                        let request : NSMutableURLRequest = NSMutableURLRequest()
                        request.url = url;
                        request.httpMethod = "GET"
                        
                        
                        let task = session.dataTask(with: request as URLRequest){data,response, error in
                            
                            guard data != nil else {
                                cell?.foto.image = UIImage(named: "Avatar")
                                return
                                
                            }
                            
                            
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if let _imagen = UIImage(data: data!) {
                                    let imagen = Utilerias.aplicarEfectoDifuminacionImagen(_imagen, intensidad: item!.restriccion)
                                    self.imagenCache[imagenURL] = imagen;
                                    if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                        cell.foto.image = imagen
                                        
                                    }
                                } else {
                                    if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                        cell.foto.image = UIImage(named: "Avatar")
                                        
                                    }
                                }
                            })
                        };
                        task.resume()
                    } else {
                        cell?.foto.image = UIImage(named: "Avatar")
                        
                    }
                    
                    
                }else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                            cell.foto.image = imagen
                            
                        }
                        
                        
                    })
                }
            }
        }
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.tab.tabSeleccionada == 1 {
            let indexPath = tableView.indexPathForSelectedRow
            var item: GeneralTableItem?
            item = self.listaNuevos[(indexPath! as NSIndexPath).row]
            DataUserDefaults.setIdVerPerfil(id: (item?.id)!)
            DataUserDefaults.setJsonPerfilPersona(json: prospectos[(indexPath! as NSIndexPath).row].description)
            DataUserDefaults.setTab(tab: 2)
            performSegue(withIdentifier: "gotoVerPerfil", sender: nil)
        }else{
            let indexPath = tableView.indexPathForSelectedRow
            var item: GeneralTableItem?
            item = self.listaChat[(indexPath! as NSIndexPath).row]
            DataUserDefaults.setIdVerPerfil(id: (item?.id)!)
            DataUserDefaults.setJsonPerfilPersona(json: mischats[(indexPath! as NSIndexPath).row].description)
            DataUserDefaults.setTab(tab: 1)
            DataUserDefaults.setNombrePersona(nombre: (item?.nombre)!)
            performSegue(withIdentifier: "gotoMesajesChat", sender: nil)
        }
    }
    
    func listarChats(){
        if Utilerias.isConnectedToNetwork(){
            let loadingView = UIView()
            let spinner = UIActivityIndicatorView()
            let loadingLabel = UILabel()
            Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
            AFManager.request(Constantes.LISTAR_MIS_CHATS, headers: self.headers)
                .responseJSON {
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if(status){
                                if !json["s1"].isEmpty{
                                    self.mischats = json["s1"].arrayValue
                                    for michat in self.mischats{
                                        
                                        let id  = michat["id"].int
                                        let nombre = michat["nombre"].string
                                        let imagen = michat["imagen"].string
                                        let foto_visible = michat["foto_visible"].floatValue
                                        let hora_ultimo = michat["hora_ultimo_mensaje"].string
                                        let ultimo_mensaje = michat["ultimo_mensaje"].string
                                        let sin_leer = michat["mensajes_sin_leer"].int
                                        let es_primer_contacto = michat["es_primer_contacto"].int
                                        var fotoUrl = String()
                                        
                                        if !(imagen?.isEmpty)!{
                                            fotoUrl = Constantes.BASE_URL
                                            fotoUrl += imagen!
                                        }
                                        
                                        self.listaChat.append(
                                            GeneralTableItem(id: id!, nombre: nombre!, distancia: "", tiempo: hora_ultimo!, lugar: "", descripcion: ultimo_mensaje!, avatar: fotoUrl, badge: String(sin_leer!), compartir: false, resaltar: false, restriccion: foto_visible)
                                        )
                                    }
                                    self.tableView.reloadData()
                                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                                }else{
                                    self.tableView.reloadData()
                                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                                }
                            }else{
                                Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
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
    
    func listarNuevosProspectos(){
        if Utilerias.isConnectedToNetwork(){
            let loadingView = UIView()
            let spinner = UIActivityIndicatorView()
            let loadingLabel = UILabel()
            Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
            AFManager.request(Constantes.LISTAR_PROSPECTOS, headers: self.headers)
                .responseJSON {
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if(status){
                                if !json["mensaje_plain"].isEmpty{
                                    self.prospectos = json["mensaje_plain"].arrayValue
                                    for prospecto in self.prospectos{
                                        var fotitos = Dictionary<String, String>()
                                        let id  = prospecto["id"].int
                                        var nombre:String = "Sin Nombre";
                                        if let nom = prospecto["nombre"].string{
                                            nombre = nom
                                        }
                                        var sobre_mi:String = "Sin descripcion"
                                        if let sobre = prospecto["sobre_mi"].string{
                                            sobre_mi = sobre
                                        }
                                        let foto_visible = prospecto["foto_visible"].floatValue
                                        var fotoUrl = String()
                                        if !prospecto["fotografias"].isEmpty{
                                            fotoUrl += Constantes.BASE_URL
                                            fotitos = prospecto["fotografias"].dictionaryObject as! Dictionary<String, String>
                                            fotoUrl += Array(fotitos.values)[0]
                                            
                                        }
                                        self.listaNuevos.append(GeneralTableItem(id: id!, nombre: nombre, distancia: "", tiempo: "", lugar: "", descripcion: sobre_mi, avatar: fotoUrl, badge: "", compartir: false, resaltar: false, restriccion: foto_visible))
                                    }
                                    self.tableView.reloadData()
                                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                                }else{
                                    self.tableView.reloadData()
                                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                                }
                            }else{
                                Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
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
        var tabGuardada:Int = 0
        tabGuardada = DataUserDefaults.getTab()
        debugPrint("Tab guardada: \(tabGuardada)")
        if tabGuardada == 0 || tabGuardada == 1{
            tab.botonIzquierda?.sendActions(for: .touchUpInside)
            //self.cambiarPrimerTab()
        }else{
            tab.botonDerecha?.sendActions(for: .touchUpInside)
            //self.cambiarSegundoTab()
        }
        let pushType = DataUserDefaults.getPushType()
        if pushType == "2"{
            pushS1ViewController()
        }else if pushType == "3"{
            self.performSegue(withIdentifier: "gotoMesajesChat", sender: nil)
        }
    }
    
    // MARK: - Acciones y eventos
    
    func cambiarPrimerTab (){
        self.listaChat.removeAll()
        self.mischats.removeAll()
        self.listaNuevos.removeAll()
        self.prospectos.removeAll()
        listarChats()
    }
    
    func cambiarSegundoTab (){
        self.listaNuevos.removeAll()
        self.prospectos.removeAll()
        self.listaChat.removeAll()
        self.mischats.removeAll()
        listarNuevosProspectos()
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
