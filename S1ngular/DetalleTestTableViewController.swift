//
//  DetalleTestTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 01/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DetalleTestTableViewController: UITableViewController {

    @IBOutlet weak var heightHeaderLabel: NSLayoutConstraint!
    @IBOutlet weak var heightImagenLabel: NSLayoutConstraint!
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var testActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var indiceLabel: UILabel!
    
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var preguntaImagenLabel: UILabel!
    @IBOutlet weak var preguntaImageView: UIImageView!
    @IBOutlet weak var preguntaImagebActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var comenzarTestView: UIView!
    
    @IBOutlet weak var respuestasTableViewCell: UITableViewCell!
    
    @IBOutlet weak var preguntaTextoCell: UITableViewCell!
    @IBOutlet weak var preguntaImagenCell: UITableViewCell!
    
    var test:Test!
    
    
    var indicePreguntaActual: Int = -1
    var testComenzado:Bool = false
    var testFinalizado:Bool = false
    
    let jsonTestString = DataUserDefaults.getJsonTest()
    var jsonTestObject : JSON?
    
    var idsRespuestasTest : [Int] = []
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var swipeRight = UISwipeGestureRecognizer()

    @IBOutlet weak var resultadoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.preguntaLabel.sizeToFit()
        
        self.comenzarTestView.layer.shadowColor = UIColor.black.cgColor
        self.comenzarTestView.layer.shadowOpacity = 0.5
        self.comenzarTestView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.comenzarTestView.layer.shadowRadius = 3
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        self.tableView.addGestureRecognizer(swipeRight)
        
        self.badgeView.layoutIfNeeded()
        self.badgeView.layer.cornerRadius = self.badgeView.bounds.height / 2
        
        if let dataFromString = jsonTestString.data(using: .utf8, allowLossyConversion: false){
            jsonTestObject = JSON(data: dataFromString)
            //debugPrint(jsonTestObject)
            let id = jsonTestObject?["test"]["id"].int
            let nombre = jsonTestObject?["test"]["nombre"].string
            var urlImage = Constantes.BASE_URL
            if let urlll = jsonTestObject?["test"]["url"].string{
                urlImage += urlll
            }
            
            let ambito = jsonTestObject?["test"]["ambito"].string
            let contestado = jsonTestObject?["test"]["contestado"].bool
            
            var preguntasTest = [TestPregunta]()
            
            if !(jsonTestObject?["test"]["preguntas"].arrayValue.isEmpty)!{
                var respuestasPregunta = [TestRespuesta]()
                let preguntasJSON: [JSON] = jsonTestObject!["test"]["preguntas"].arrayValue
                for pregunta in preguntasJSON{
                    let idP = pregunta["id"].int
                    let preg = pregunta["descripcion"].string
                    let tipoP = pregunta["tipo"].int == 1 ? TipoPregunta.texto : TipoPregunta.imagen
                    let tipoRes = TipoRespuesta.texto
                    var url = Constantes.BASE_URL
                    url += pregunta["url"].string!
                    if !pregunta["respuestas"].arrayValue.isEmpty{
                        let respuestasJSON: [JSON] = pregunta["respuestas"].arrayValue
                        for respuesta in respuestasJSON{
                            /*Extrayendo respuesta*/
                            let idR = respuesta["id"].int
                            let descR = respuesta["descripcion"].string
                            var urlR = Constantes.BASE_URL
                            urlR += respuesta["url"].string!
                            
                            let respuestaPregunta = TestRespuesta(id: idR!, respuesta: descR!, descripcion: "", imagen: urlR)
                            
                            /*Agregando respuesta al array de respuestas*/
                            respuestasPregunta.append(respuestaPregunta)
                        }
                    }
                    let preguntaTest = TestPregunta(id: idP!, pregunta: preg!, tipo: tipoP, imagen: url, tipoRespuestas: tipoRes, respuestas: respuestasPregunta)
                    respuestasPregunta.removeAll()
                    preguntasTest.append(preguntaTest)
                }
                let testCompleto = Test(id: id!, nombre: nombre!, descripcion: "", tag: "", costo: 0, recompensa: 0, imagen: urlImage, preguntas: preguntasTest, ambito: ambito!, contestado: contestado!)
                self.test = testCompleto
            }
        }
        /*Porque truena aqui?????*/
        self.testLabel.text = test.nombre
        self.testLabel.layoutIfNeeded()
        self.testLabel.sizeToFit()
        
        
        self.heightHeaderLabel.constant = self.testLabel.bounds.height + 41
        self.tagLabel.text = test.ambito
        
        self.preguntaLabel.text = self.test.descripcion
        self.indiceLabel.text = "0 / \(self.test.preguntas.count)"
        
        self.comenzarTestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.comenzarTest)))
        
        
        
        
        let url:URL = URL(string: test.imagen )!
        let session = URLSession.shared;
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = url;
        request.httpMethod = "GET"
        
        self.testActivityIndicator.startAnimating()
        let task = session.dataTask(with: request as URLRequest){data,response, error in
            
            
            guard data != nil else {
                self.testImageView.image = nil
                DispatchQueue.main.async(execute: { () -> Void in
                    self.testActivityIndicator.stopAnimating()
                })
                return
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let imagen = UIImage(data: data!) {
                    self.testImageView.image = imagen
                    
                } else {
                    self.testImageView.image = nil
                }
                self.testActivityIndicator.stopAnimating()
            })
        };
        task.resume()
        
        if DataUserDefaults.isTestPendiente(){
            self.parent?.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
    }
    
    
    
    func respondToSwipeRight(gesture: UISwipeGestureRecognizer){
        preguntaAnterior()
        debugPrint("Swiping Rightttt")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Header
        if indexPath.row == 0 {
            return 200
        }
        
        // Pregunta
        if  indexPath.row == 1 && !testComenzado && !self.testFinalizado{
            
            return self.preguntaLabel.bounds.height + 16
        }
        
        if !self.testFinalizado && testComenzado && indexPath.row == 1 && self.test.preguntas[self.indicePreguntaActual].tipo == .texto  {
            
            return self.preguntaLabel.bounds.height + 16
        }
        
        // Pregunta con imagen
        if !self.testFinalizado &&  indexPath.row == 2 && testComenzado && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipo == .imagen  {
            return 200
        }
        
        // Comenzar el test
        if indexPath.row == 3 && !testComenzado && !self.testFinalizado{
            return 78
        }
        
        
        // aquí va a depender de las respuestas
        
        if !self.testFinalizado && indexPath.row == 4 && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipoRespuestas == .texto  {
            let total = CGFloat(self.test.preguntas[self.indicePreguntaActual].respuestas.count)
            return (total * 45.0) + (total * 16) + 16.0
        }
        
        if !self.testFinalizado && indexPath.row == 4 && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipoRespuestas == .color  {
           
            
            let total = CGFloat(self.test.preguntas[self.indicePreguntaActual].respuestas.count)
            
            return ceil(total / 2) * (self.tableView.bounds.width / 2)
        }
        
        if indexPath.row == 5 && self.testFinalizado {
            return 44
        }
        
        if indexPath.row == 6 && self.testFinalizado {
            
            return self.resultadoLabel.bounds.height + 16
        }
        
         return 0
        // return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if testComenzado {
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
    
    
    // MARK: - Actions y Eventos
    
    func comenzarTest() {
        self.testComenzado = true
        //self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        self.parent?.navigationItem.leftBarButtonItem?.isEnabled = false
        DataUserDefaults.setTestPendiente(flag: true)
        self.siguientePregunta()
    }
    
    func preguntaAnterior(){
        if self.indicePreguntaActual > 0{
            self.indicePreguntaActual -= 1
            self.idsRespuestasTest.removeLast()
            debugPrint(self.idsRespuestasTest.description)
            let pregunta = self.test.preguntas[self.indicePreguntaActual]
            if pregunta.tipo == .texto {
                self.preguntaLabel.text = pregunta.pregunta
                self.preguntaLabel.sizeToFit()
            } else {
                self.preguntaImagenLabel.text = pregunta.pregunta
                self.preguntaImagenLabel.layoutIfNeeded()
                self.preguntaImagenLabel.sizeToFit()
                self.heightImagenLabel.constant = self.preguntaImagenLabel.bounds.height + 16
                
                
                let url:URL = URL(string: pregunta.imagen )!
                let session = URLSession.shared;
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = url;
                request.httpMethod = "GET"
                
                self.preguntaImagebActivityIndicator.startAnimating()
                let task = session.dataTask(with: request as URLRequest){data,response, error in
                    
                    
                    guard data != nil else {
                        self.preguntaImageView.image = nil
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.preguntaImagebActivityIndicator.stopAnimating()
                        })
                        return
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let imagen = UIImage(data: data!) {
                            self.preguntaImageView.image = imagen
                            
                        } else {
                            self.preguntaImageView.image = nil
                        }
                        self.preguntaImagebActivityIndicator.stopAnimating()
                    })
                };
                task.resume()
            }
            self.indiceLabel.text = "\(self.indicePreguntaActual + 1) / \(self.test.preguntas.count)"
            self.respuestasTableViewCell.contentView.subviews.forEach({ $0.removeFromSuperview()  })
            
            var i = CGFloat(0)
            var line = CGFloat(0)
            for respuesta in pregunta.respuestas {
                if pregunta.tipoRespuestas == .texto {
                    let button = ClearButtonRounded(frame: CGRect(x: 8.0, y: 45 * i + 16 * (i + 1), width: self.tableView.bounds.width - 16, height: 45))
                    
                    button.setTitle(respuesta.respuesta, for: UIControlState.normal)
                    //button.id = respuesta.id
                    
                    button.tag = respuesta.id
                    
                    button.addTarget(self, action: #selector(self.seleccionarRespuesta(sender:)), for: UIControlEvents.touchUpInside)
                    self.respuestasTableViewCell.contentView.addSubview(button)
                }
                
                if pregunta.tipoRespuestas == .color {
                    let side = self.tableView.bounds.width / 2
                    
                    let x = (Int(i) + 1) % 2 == 0 ? side : 0.0
                    if i > 1 {
                        line = x == 0.0 ? line + 1 : line
                    }
                    
                    let view = UIView(frame: CGRect(x: x, y: line * side, width: side, height: side))
                    view.backgroundColor = respuesta.color
                    view.tag = respuesta.id
                    
                    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarColor(sender:))))
                    self.respuestasTableViewCell.contentView.addSubview(view)
                    
                }
                
                i += 1
            }
            
            self.tableView.reloadData()
            
        }else{
            debugPrint("No puedes ir atras, es la primera pregunta.")
        }
        
    }
    func siguientePregunta() {
        
        self.indicePreguntaActual += 1
        
        guard self.indicePreguntaActual < self.test.preguntas.count else {
            self.testFinalizado = true
            
            self.parent?.navigationItem.leftBarButtonItem?.isEnabled = false
            //_ = self.navigationController?.popViewController(animated: true)
            
            self.responderTestS1(idTest: self.test.id)
            
            // Hay qu epensar en algo
            self.resultadoLabel.text = "Test finalizado, gracias."
            self.resultadoLabel.sizeToFit()
            self.tableView.reloadData()
            return
        }
        
        let pregunta = self.test.preguntas[self.indicePreguntaActual]
        
        debugPrint(pregunta)
        
        if pregunta.tipo == .texto {
            self.preguntaLabel.text = pregunta.pregunta
            self.preguntaLabel.sizeToFit()
        } else {
            self.preguntaImagenLabel.text = pregunta.pregunta
            self.preguntaImagenLabel.layoutIfNeeded()
            self.preguntaImagenLabel.sizeToFit()
            self.heightImagenLabel.constant = self.preguntaImagenLabel.bounds.height + 16
            
            
            let url:URL = URL(string: pregunta.imagen )!
            let session = URLSession.shared;
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = url;
            request.httpMethod = "GET"
            
            self.preguntaImagebActivityIndicator.startAnimating()
            let task = session.dataTask(with: request as URLRequest){data,response, error in
                
                
                guard data != nil else {
                    self.preguntaImageView.image = nil
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.preguntaImagebActivityIndicator.stopAnimating()
                    })
                    return
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if let imagen = UIImage(data: data!) {
                        self.preguntaImageView.image = imagen
                        
                    } else {
                        self.preguntaImageView.image = nil
                    }
                    self.preguntaImagebActivityIndicator.stopAnimating()
                })
            };
            task.resume()
            
            
        }
        
        self.indiceLabel.text = "\(self.indicePreguntaActual + 1) / \(self.test.preguntas.count)"
        
        self.respuestasTableViewCell.contentView.subviews.forEach({ $0.removeFromSuperview()  })
        
        var i = CGFloat(0)
        var line = CGFloat(0)
        for respuesta in pregunta.respuestas {
            if pregunta.tipoRespuestas == .texto {
                let button = ClearButtonRounded(frame: CGRect(x: 8.0, y: 45 * i + 16 * (i + 1), width: self.tableView.bounds.width - 16, height: 45))
                
                button.setTitle(respuesta.respuesta, for: UIControlState.normal)
                //button.id = respuesta.id
                
                button.tag = respuesta.id
                
                button.addTarget(self, action: #selector(self.seleccionarRespuesta(sender:)), for: UIControlEvents.touchUpInside)
                self.respuestasTableViewCell.contentView.addSubview(button)
            }
            
            if pregunta.tipoRespuestas == .color {
                let side = self.tableView.bounds.width / 2
                
                let x = (Int(i) + 1) % 2 == 0 ? side : 0.0
                if i > 1 {
                    line = x == 0.0 ? line + 1 : line
                }
                
                let view = UIView(frame: CGRect(x: x, y: line * side, width: side, height: side))
                view.backgroundColor = respuesta.color
                view.tag = respuesta.id
                
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarColor(sender:))))
                self.respuestasTableViewCell.contentView.addSubview(view)
                
            }
            
            i += 1
        }
        
        self.tableView.reloadData()
        
        
        
    }
    
    func seleccionarRespuesta(sender: UIView){
        print(sender.tag)
        self.idsRespuestasTest.append(sender.tag)
        self.siguientePregunta()
        debugPrint(self.idsRespuestasTest.description)
    }
    func seleccionarColor(sender: UIGestureRecognizer){
        print(sender.view?.tag)
        self.idsRespuestasTest.append((sender.view?.tag)!)
        self.siguientePregunta()
        debugPrint(self.idsRespuestasTest.description)
    }
    
    func responderTestS1(idTest:Int){
        let loadingView = UIView()
        let loadinLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadinLabel, spinner: spinner)
        debugPrint(self.idsRespuestasTest)
        let parameters: Parameters = [
            "id_test": idTest,
            "respuestas": self.idsRespuestasTest
        ]
        Alamofire.request(Constantes.RESPONDER_TEST, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        DataUserDefaults.setTestPendiente(flag: false)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoResultado"), object: nil)
                    }else{
                        if let message = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error", message: message)
                        }
                        
                    }
                    Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadinLabel, spinner: spinner)
                }
        }
    }
    
    func showAlertWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
