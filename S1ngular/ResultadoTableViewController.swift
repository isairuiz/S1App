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


class ResultadoTableViewController: UITableViewController{
    
    @IBOutlet weak var nombreTest: UILabel!
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    @IBOutlet weak var tituloResultadoTest: UILabel!
    @IBOutlet weak var categoriaTest: UILabel!
    @IBOutlet weak var descripcionResultadoTEst: UITextView!
    @IBOutlet weak var imagenTest: UIImageView!
    var urlImagenResultadoTest = String()
    
    var shareButton = ShareButton<LinkShareContent>()
    
    @IBOutlet weak var responderNuevoCell: UITableViewCell!
    
    @IBOutlet weak var compartirCheckInViewButton: UIView!
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var idTest = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        let compartirTestTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirTestTap)
        
        //let responderNuevoTap = UITapGestureRecognizer(target: self, action: #selector(self.responderNuevo))
        //self.responderNuevoCell.addGestureRecognizer(responderNuevoTap)

        
        /*shareButton.layer.shadowColor = UIColor.black.cgColor
        shareButton.layer.shadowOpacity = 0.5
        shareButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        shareButton.layer.shadowRadius = 3*/
        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
        

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
        
        
        var content = LinkShareContent(url: URL(string: "http://s1ngular.com/")! )
        var desc:String = "Finalice con exito un test en S1ngular: "
        desc += self.nombreTest.text!
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
        let view = UIView()
        let label = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: view, tableView: self.tableView, loadingLabel: label, spinner: spinner)
        var urlFinal = Constantes.VER_RESULTADO_TEST
        urlFinal += idTest
        Alamofire.request(urlFinal, headers: self.headers)
            .responseJSON{
                response in
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

    // MARK: - Table view data source

}
