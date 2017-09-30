//
//  ResultadoTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 04/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FacebookShare
import FacebookCore
import Social


class ResultadoTableViewController: UITableViewController{
    
    @IBOutlet weak var nombreTest: UILabel!
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    @IBOutlet weak var tituloResultadoTest: UILabel!
    @IBOutlet weak var categoriaTest: UILabel!
    @IBOutlet weak var descripcionResultadoTEst: UITextView!
    @IBOutlet weak var imagenTest: UIImageView!
    var urlImagenResultadoTest = String()
    
    @IBOutlet weak var reiniciarTestTableViewCell: UITableViewCell!
    var shareButton = ShareButton<LinkShareContent>()
    
    @IBOutlet weak var compartirCheckInViewButton: UIView!
    @IBOutlet weak var reinicarTestViewButton: UIView!
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var idTest = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        let compartirTestTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirTestTap)
        
        let responderNuevoTap = UITapGestureRecognizer(target: self, action: #selector(self.responderNuevo))
        self.reiniciarTestTableViewCell.addGestureRecognizer(responderNuevoTap)

        
        /*shareButton.layer.shadowColor = UIColor.black.cgColor
        shareButton.layer.shadowOpacity = 0.5
        shareButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        shareButton.layer.shadowRadius = 3*/
        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
        
        
        self.reinicarTestViewButton.layer.shadowColor = UIColor.black.cgColor
        self.reinicarTestViewButton.layer.shadowOpacity = 0.5
        self.reinicarTestViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.reinicarTestViewButton.layer.shadowRadius = 3
        

        self.idTest = DataUserDefaults.getIdComprarTest()
        self.verMiResultado(idTest: String(describing: idTest))
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*shareButton = ShareButton(frame: CGRect(x: 0, y: 0, width: self.compartirCheckInTableViewCell.frame.maxX - 10, height: self.compartirCheckInTableViewCell.frame.maxY - 10), content: content)
        shareButton.center = self.compartirCheckInTableViewCell.center
        self.compartirCheckInTableViewCell.addSubview(shareButton)*/
    }
    
    
    func compartirCheckIn(){
        
        print("compartir")
        
        
        //var content = LinkShareContent(url: URL(string: "http://s1ngular.com/")! )
        var desc:String = "Finalice con exito un test en S1ngular:"
        desc += self.nombreTest.text!
        /*content.description = desc
        content.imageURL = URL(string: self.urlImagenResultadoTest)
        content.quote = desc
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            debugPrint(result)
        }
        do{
            try shareDialog.show()
        }catch{
            debugPrint(error)
        }*/
        
        let photo = Photo(image: self.imagenTest.image!, userGenerated: true)
        var content = PhotoShareContent(photos: [photo])
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            debugPrint(result)
        }
        do{
            try shareDialog.show()
        }catch{
            debugPrint(error)
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
    
    
    func verMiResultado(idTest:String){
        if Utilerias.isConnectedToNetwork(){
            let view = UIView()
            let label = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: view, tableView: self.tableView, loadingLabel: label, spinner: spinner)
            var urlFinal = Constantes.VER_RESULTADO_TEST
            urlFinal += idTest
            AFManager.request(urlFinal, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if status{
                                
                                if let nombre = json["resultado"]["nombre_test"].string{
                                    self.nombreTest.text = nombre
                                }
                                if let imagen = json["resultado"]["imagenresultado"].string{
                                    var url = Constantes.BASE_URL
                                    url += imagen
                                    self.urlImagenResultadoTest = url
                                    self.imagenTest.downloadedFrom(link: url,withBlur:false,maxBlur:0)
                                }
                                if let puntaje = json["resultado"]["puntaje"].int{
                                    
                                }
                                if let ambito = json["resultado"]["ambito"].string{
                                    self.categoriaTest.text = ambito
                                }
                                if let resultadoNombre = json["resultado"]["resultado"].string{
                                    self.tituloResultadoTest.text = resultadoNombre
                                }
                                if let contenido = json["resultado"]["contenido"].string{
                                    self.descripcionResultadoTEst.text = contenido
                                }
                                self.tableView.reloadData()
                                Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
                            }else{
                                Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 300
        }else if indexPath.row == 1{
            return UITableViewAutomaticDimension
        }else {
            return 78
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func responderNuevo(){
        let alert = UIAlertController(title: "¿Deseas responder nuevamente este test?", message: "Contesta de nuevo para encontrar a nuevos s1ngulares. Se descontara nuevamente el costo del test de tus S1 Credits.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
            let idTest:Int = DataUserDefaults.getIdComprarTest()
            self.resetearTest(idTest: idTest)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func resetearTest(idTest:Int){
        if Utilerias.isConnectedToNetwork(){
            let lView = UIView()
            let lLabel = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
            let parameters: Parameters = ["id": idTest]
            AFManager.request(Constantes.RESET_TEST, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                            if status{
                                /*hacer aqui la funcionalidad para regresar e ir a contestar test.*/
                                DataUserDefaults.setJsonTest(json: json.description)
                                DataUserDefaults.setAdquirido(flag: true)
                                
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is TestsTableViewController {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                                
                                
                            }else{
                                if let errorMessage = json["mensaje_plain"].string{
                                    self.alertWithMessage(title: "Error", message: errorMessage)
                                }
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
    

    // MARK: - Table view data source

}
