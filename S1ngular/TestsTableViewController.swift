//
//  TestsTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 17/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TestsTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaResultados:[TestItem] = []
    var listaNuevos:[TestItem] = []
    var itemTestComprado:Test?
    
    var saldo = UILabel(frame:(CGRect(x: 40, y: 0, width: 58, height: 37)))
    
    @IBOutlet weak var labelnfo: UILabel!
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var jsonTests : [JSON]? = [JSON.null]
    
    var theTEST: Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        
        let img = UIImage(named: "TagSaldo")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        let rightButton = UIButton(type: UIButtonType.custom)
        //rightButton.addTarget(self, action: #selector(self.verSaldo), for: UIControlEvents.touchUpInside)
        rightButton.setImage(img, for: UIControlState.normal)
      
        rightButton.frame = CGRect(x: 0, y: 0, width: 103, height: 37)
        
        
        
        saldo.text = "\(DataUserDefaults.getSaldo())"
        saldo.textColor = UIColor.white
        saldo.font = UIFont(name: "BrandonGrotesque-Bold", size: 15)!
        saldo.textAlignment = .center
        
        rightButton.addSubview(saldo)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("NUEVOS", derecha: "RESULTADOS")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        let tabGuardada:Int = 0
        guard tabGuardada == DataUserDefaults.getTab() else{
            return
        }
        if tabGuardada == 0 || tabGuardada == 1{
            tab.botonIzquierda?.sendActions(for: .touchUpInside)
        }else{
            tab.botonDerecha?.sendActions(for: .touchUpInside)
        }
        
        DataUserDefaults.setTab(tab: 1)
        
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
        if section == 1{
            return 0
        }
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tab.tabSeleccionada == 0 {
            if !self.listaNuevos.isEmpty{
                if indexPath.section == 1{
                    return 0
                }
            }
            return 140
        }else{
            if !self.listaResultados.isEmpty{
                if indexPath.section == 1{
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.tab.tabSeleccionada == 0 {
            debugPrint("seleccionada 0")
            if self.listaNuevos.isEmpty{
                debugPrint("lista vacia")
                if section == 1{
                    debugPrint("section 0")
                    return 1
                }
                if section == 0{
                    debugPrint("section 1")
                    return 0
                }
            }else{
                debugPrint("lista no vacia")
                if section == 1{
                    debugPrint("section 0")
                    return 0
                }
                if section == 0{
                    debugPrint("section 1")
                    return self.listaNuevos.count
                }
            }
            
        }else if tab.tabSeleccionada == 1{
            debugPrint("seleccionada 1")
            if self.listaResultados.isEmpty{
                debugPrint("lista vacia")
                if section == 1{
                    return 1
                    debugPrint("section 0")
                }
                if section == 0{
                    debugPrint("section 1")
                    return 0
                }
            }else{
                debugPrint("lista no vacia")
                if section == 1{
                    debugPrint("section 0")
                    return 0
                }
            }
        }
        return self.listaResultados.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
            return cell
        }
        
        let cell = self.tab.tabSeleccionada == 0 ? tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) : tableView.dequeueReusableCell(withIdentifier: "CeldaResultados", for: indexPath)
        
        // Configure the cell...
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        var imagenURL:String = ""
        
        var item: TestItem?
        
        if self.tab.tabSeleccionada == 0 {
            
            item = self.listaNuevos[(indexPath as NSIndexPath).row]
  
            let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
            (cell.viewWithTag(2) as? UILabel)?.attributedText = descripcion
            (cell.viewWithTag(2) as? UILabel)?.lineBreakMode = .byTruncatingTail
            
            (cell.viewWithTag(3) as? UILabel)?.text = "RECOMPENZA: \(item!.recompensa) S1NGLE CREDITS"
            (cell.viewWithTag(4) as? UILabel)?.text = "-\(item!.costo)"
            
        } else{
            item = self.listaResultados[(indexPath as NSIndexPath).row]
            
            let descripcion = NSMutableAttributedString(string: "Resultado:\n\(item!.resultado)", attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
            (cell.viewWithTag(2) as? UILabel)?.attributedText = descripcion
            (cell.viewWithTag(2) as? UILabel)?.lineBreakMode = .byTruncatingTail
            
            (cell.viewWithTag(3) as? UILabel)?.text = "+ \(item!.recompensa) S1NGLE CREDITS"
            
            (cell.viewWithTag(6) as? UIButton)?.layoutIfNeeded()
            (cell.viewWithTag(6) as? UIButton)?.layer.cornerRadius = ((cell.viewWithTag(6) as? UIButton)?.bounds.height)! / 2
            
        }
        
        (cell.viewWithTag(1) as? UILabel)?.text = item!.nombre
        
        imagenURL = item!.imagen
        
        let imagen =  self.imagenCache[imagenURL];
        (cell.viewWithTag(5) as? UIImageView)?.image = nil
        
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
                        (cell.viewWithTag(5) as? UIImageView)?.image = nil
                        return
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let imagen = UIImage(data: data!) {
                            self.imagenCache[imagenURL] = imagen;
                            if let cell = tableView.cellForRow(at: indexPath) {
                                
                                (cell.viewWithTag(5) as? UIImageView)?.image = imagen
                                
                            }
                        } else {
                            if let cell = tableView.cellForRow(at: indexPath) {
                                (cell.viewWithTag(5) as? UIImageView)?.image = nil
                            }
                        }
                    })
                };
                task.resume()
            } else {
                (cell.viewWithTag(5) as? UIImageView)?.image = nil
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = tableView.cellForRow(at: indexPath) {
                    (cell.viewWithTag(5) as? UIImageView)?.image = imagen
                }
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: TestItem?
        var itemRes: TestItem?
        if self.tab.tabSeleccionada == 0 {
            /*let alert = UIAlertController(title: "¿Desea comprar este test?", message: "Se descontara el costo del test de sus S1 Credits", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Lo quiero", style: UIAlertActionStyle.default, handler: { action in
                item = self.listaNuevos[(indexPath as NSIndexPath).row]
                self.comprarTest(id: (item?.id)!,costo:(item?.costo)!)
                DataUserDefaults.setIdComprarTest(idTest: (item?.id)!)
                
            }))
            alert.addAction(UIAlertAction(title: "No lo quiero", style: UIAlertActionStyle.cancel, handler: {action in
                
            }))
            self.present(alert, animated: true, completion: nil)*/
            item = self.listaNuevos[(indexPath as NSIndexPath).row]
            DataUserDefaults.setJsonTest(json: (self.jsonTests?[(indexPath as NSIndexPath).row].description)!)
            DataUserDefaults.setIdComprarTest(idTest: (item?.id)!)
            self.performSegue(withIdentifier: "MostrarTest", sender: self)
            
        }else{
            /*itemRes = self.listaResultados[(indexPath as NSIndexPath).row]
            let alert = UIAlertController(title: "Selecciona una acción", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "Ver resultado", style: UIAlertActionStyle.default, handler: { action in
                
                DataUserDefaults.setIdComprarTest(idTest: (itemRes?.id)!)
                self.performSegue(withIdentifier: "MostrarResultadoSegue", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Reiniciar Test", style: UIAlertActionStyle.default, handler: {action in
                DataUserDefaults.setIdComprarTest(idTest: (itemRes?.id)!)
                self.responderNuevo(idTest: (itemRes?.id)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)*/
            
            itemRes = self.listaResultados[(indexPath as NSIndexPath).row]
            DataUserDefaults.setIdComprarTest(idTest: (itemRes?.id)!)
            self.performSegue(withIdentifier: "MostrarResultadoSegue", sender: nil)
            
        }
        
    }
    
   
    
    
   
    // MARK: - Acciones y eventos
    
    func comprarTest(id:Int,costo:Int){
        let parameters: Parameters = ["id": id]
        Alamofire.request(Constantes.COMPRAR_TEST_URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        DataUserDefaults.setJsonTest(json: json.description)
                        self.restarSaldo(costo: costo)
                        self.performSegue(withIdentifier: "MostrarTest", sender: self)
                    }else{
                        if let message = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error", message: message)
                        }
                    }
                }
        }
        
    }
    
    func showAlertWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func obtenerMisResultados(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.MIS_RESULTADOS_TEST, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["resultados"].isEmpty{
                            var resultados : [JSON] = json["resultados"].arrayValue
                            for res in resultados{
                                let idTest  = res["id_test"].int
                                let nombre = res["nombre_test"].string
                                let imgTest = res["imagentest"].string
                                let imgRes = res["imagenresultado"].string
                                let puntaje = res["puntaje"].int
                                let nombreRes = res["resultado"].string
                                let contenido = res["contenido"].string
                                var urlImg = Constantes.BASE_URL
                                urlImg += imgRes!
                                self.listaResultados.append(TestItem(id: idTest!, nombre: nombre!, descripcion: contenido!, costo: 0, recompensa: 0, imagen: urlImg, resultado:nombreRes!, preguntas: 0))
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
        }
    }
    
    func obtenerTestsNuevos(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.LISTAR_TESTS_URL, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["mensaje_plain"].isEmpty{
                            self.jsonTests? = json["mensaje_plain"].arrayValue
                            for test in self.jsonTests!{
                                var urlImagen = Constantes.BASE_URL
                                let id = test["id"].int
                                let nombre = test["nombre"].string
                                let descripcion = test["descripcion"].string
                                urlImagen += test["url"].string!
                                let preguntas = test["preguntas"].int
                                let costo = test["costo"].int
                                let recompensa = test["recompensa"].int
                                self.listaNuevos.append(TestItem(id: id!, nombre: nombre!, descripcion: descripcion!, costo: costo!, recompensa: recompensa!, imagen: urlImagen, preguntas:preguntas!))
                            }
                            self.tableView.reloadData()
                            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        }
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        var tabGuardada:Int = 0
        tabGuardada = DataUserDefaults.getTab()
        debugPrint("Tab guardada: \(tabGuardada)")
        if tabGuardada == 0 || tabGuardada == 1{
            tab.botonIzquierda?.sendActions(for: .touchUpInside)
            if DataUserDefaults.isTestPendiente(){
                let alert = UIAlertController(title: "Un momento", message: "Tienes un test pendiente, debes contestarlo para poder avanzar.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Terminar test", style: UIAlertActionStyle.default, handler: { action in
                    self.performSegue(withIdentifier: "MostrarTest", sender: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            tab.botonDerecha?.sendActions(for: .touchUpInside)
            //self.cambiarSegundoTab()
        }
        
        if(DataUserDefaults.fueAdquirido()){
            
            self.performSegue(withIdentifier: "MostrarTest", sender: self)
        }
        
    }

    
    func cambiarPrimerTab (){
        self.listaNuevos.removeAll()
        obtenerTestsNuevos()
    }
    
    func cambiarSegundoTab (){
        self.listaResultados.removeAll()
        obtenerMisResultados()
    }
    
    func restarSaldo(costo:Int){
        let saldoActual:Int = Int(saldo.text!)!
        let nuevoSaldo:Int = saldoActual - costo
        saldo.text = "\(nuevoSaldo)"
    }
    func verSaldo(){
        saldo.text = "100000"
    }

}
