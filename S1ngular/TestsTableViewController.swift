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
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var theTEST: Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        
        let img = UIImage(named: "TagSaldo")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.addTarget(self, action: #selector(self.verSaldo), for: UIControlEvents.touchUpInside)
        rightButton.setImage(img, for: UIControlState.normal)
      
        rightButton.frame = CGRect(x: 0, y: 0, width: 103, height: 37)
        
        
        
        saldo.text = "\(DataUserDefaults.getSaldo())"
        saldo.textColor = UIColor.white
        saldo.font = UIFont(name: "BrandonGrotesque-Bold", size: 15)!
        saldo.textAlignment = .center
        
        rightButton.addSubview(saldo)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        /*if DataUserDefaults.getFromTabTestResult(){
            tab.tabSeleccionada = 1
        }*/
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("NUEVOS", derecha: "RESULTADOS")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        /*listaNuevos = [
            TestItem(id: 1, nombre: "HABLEMOS DE SEXO", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 50, recompensa: 1000, imagen: "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg"),
            TestItem(id: 1, nombre: "ZODIACO S1NGULAR", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 10, recompensa: 50, imagen: "https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1"),
            TestItem(id: 1, nombre: "TIPOS DE SOLTERO", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 20, recompensa: 100, imagen: "http://i.dailymail.co.uk/i/pix/2015/05/29/02/2929496B00000578-3101635-image-a-1_1432862935225.jpg")
        ]*/
        
        listaResultados = [
            TestItem(id: 1, nombre: "PREFERENCIAS EN LA CAMA", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 50, recompensa: 1000, imagen: "http://mommyatozblog.com/wp-content/uploads/2014/10/couple-in-bed.jpg?w=300", resultado:"¡Eres una tigresa a full!", preguntas:0),
            TestItem(id: 1, nombre: "JUEGOS SEXUALES", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 10, recompensa: 50, imagen: "http://www.appsgalery.com/pictures/000/140/-exy--ames-140523.png",resultado:"¡Eres una tigresa a full!",preguntas:0)
        ]
        
        self.obtenerTestsNuevos()
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
        if self.tab.tabSeleccionada == 0 {
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tab.tabSeleccionada == 0 {
            return 140
        }
        return 108
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tab
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.tab.tabSeleccionada == 0 {
            return self.listaNuevos.count
        }
        
        return self.listaResultados.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
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
            
            (cell.viewWithTag(3) as? UILabel)?.text = "+ \(item!.recompensa) S1NGLE CREDITS"
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
        
        if self.tab.tabSeleccionada == 0 {
            let alert = UIAlertController(title: "¿Desea comprar este test?", message: "Se descontara el costo del test de sus S1 Credits", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Lo quiero", style: UIAlertActionStyle.default, handler: { action in
                item = self.listaNuevos[(indexPath as NSIndexPath).row]
                self.comprarTest(id: (item?.id)!)
                //self.performSegue(withIdentifier: "MostrarTest", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "No lo quiero", style: UIAlertActionStyle.cancel, handler: {action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            item = self.listaResultados[(indexPath as NSIndexPath).row]
            //DataUserDefaults.setIdComprarTest(idTest: (item?.id)!)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MostrarTest"{
            let test = segue.destination as! MostrarTestViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            test.item = self.listaNuevos[(indexPath?.row)!]
        }
    }
    // MARK: - Acciones y eventos
    
    func comprarTest(id:Int){
        let parameters: Parameters = ["id": id]
        Alamofire.request(Constantes.COMPRAR_TEST_URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        /*Extrayendo datos de test*/
                        let id = json["test"]["id"].int
                        let nombre = json["test"]["nombre"].string
                        let urlImage = json["test"]["url"].string
                        let ambito = json["test"]["ambito"].string
                        let contestado = json["test"]["contestado"].bool
                        var preguntasAll = [TestPregunta]()
                        var respuestasAll = [TestRespuesta]()
                        if !json["test"]["preguntas"].arrayValue.isEmpty{
                            /*Extrayendo preguntas*/
                            let preguntasJSON: [JSON] = json["test"]["preguntas"].arrayValue
                            for pregunta in preguntasJSON{
                                /*Extrayendo pregunta*/
                                let idP = pregunta["id"].int
                                let preg = pregunta["descripcion"].string
                                let tipoP = pregunta["tipo"].int == 1 ? TipoPregunta.texto : TipoPregunta.imagen
                                let tipoRes = TipoRespuesta.texto
                                var url = Constantes.BASE_URL
                                url += pregunta["url"].string!
                                if !pregunta["respuestas"].arrayValue.isEmpty{
                                    /*extrayendo respuestas*/
                                    let respuestasJSON: [JSON] = pregunta["respuestas"].arrayValue
                                    for respuesta in respuestasJSON{
                                        /*Extrayendo respuesta*/
                                        let idR = respuesta["id"].int
                                        let descR = respuesta["descripcion"].string
                                        var urlR = Constantes.BASE_URL
                                        urlR += respuesta["url"].string!
                                        
                                        let respuestaPregunta = TestRespuesta(id: idR!, descripcion: descR!, imagen: urlR)
                                        
                                        /*Agregando respuesta al array de respuestas*/
                                        respuestasAll.append(respuestaPregunta)
                                    }
                                    debugPrint("Respuestas de pregunta:\(String(describing: idP))----->\(respuestasAll)")
                                }
                                
                                let preguntaTest = TestPregunta(id: idP!, pregunta: preg!, tipo: tipoP, imagen: url, tipoRespuestas: tipoRes, respuestas: respuestasAll)
                                
                                /*Agregando pregunta al array de preguntas*/
                                preguntasAll.append(preguntaTest)
                            }
                            debugPrint("Preguntas de test:\(String(describing: id))\n------>\(preguntasAll)")
                            let testCompleto = Test(id: id!, nombre: nombre!, descripcion: "", tag: "", costo: 0, recompensa: 0, imagen: urlImage!, preguntas: preguntasAll, ambito: ambito!, contestado: contestado!)
                            
                            self.theTEST = testCompleto
                            debugPrint("El teste completo:\(String(describing: self.theTEST))")
                            
                        }
                    }else{
                        
                    }
                }
        }
        
    }
    
    func obtenerTestsNuevos(){
        Utilerias.setCustomLoadingScreen(loadingView: self.loadingView, tableView: self.tableView, loadingLabel: self.loadingLabel, spinner: self.spinner)
        Alamofire.request(Constantes.LISTAR_TESTS_URL, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["mensaje_plain"].isEmpty{
                            var jsonTests : [JSON] = json["mensaje_plain"].arrayValue
                            for test in jsonTests{
                                var urlImagen = Constantes.BASE_URL
                                let id = test["id"].int
                                let nombre = test["nombre"].string
                                let descripcion = test["descripcion"].string
                                urlImagen += test["url"].string!
                                let preguntas = test["preguntas"].int
                                self.listaNuevos.append(TestItem(id: id!, nombre: nombre!, descripcion: descripcion!, costo: 0, recompensa: 0, imagen: urlImagen, preguntas:preguntas!))
                            }
                            self.tableView.reloadData()
                            Utilerias.removeCustomLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner)
                        }
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner)
                    }
                }
        }
    }
    func obtenerMisResultados(){
        
    }
    
    func cambiarPrimerTab (){
        self.tableView.reloadData()
    }
    
    func cambiarSegundoTab (){
        self.tableView.reloadData()
    }
    
    func verSaldo(){
        saldo.text = "100000"
    }

}
