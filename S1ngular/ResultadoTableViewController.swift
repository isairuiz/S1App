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

class ResultadoTableViewController: UITableViewController {
    
    @IBOutlet weak var nombreTest: UILabel!
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    @IBOutlet weak var tituloResultadoTest: UILabel!
    @IBOutlet weak var categoriaTest: UILabel!
    @IBOutlet weak var descripcionResultadoTEst: UITextView!
    @IBOutlet weak var imagenTest: UIImageView!
    
    
    @IBOutlet weak var compartirCheckInViewButton: UIView!
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        let compartirCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirCheckInTap)

        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
        
        let idTest = DataUserDefaults.getIdComprarTest()
        self.verMiResultado(idTest: String(describing: idTest))
        
    }
    
    func compartirCheckIn(){
        
        print("compartir")
        
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
                            self.imagenTest.downloadedFrom(link: url,withBlur:false,maxBlur:0)
                        }
                        if let puntaje = json["resultado"]["puntaje"].int{
                            
                        }
                        if let resultadoNombre = json["resultado"]["resultado"].string{
                            self.tituloResultadoTest.text = resultadoNombre
                        }
                        if let contenido = json["resultado"]["contenido"].string{
                            self.descripcionResultadoTEst.text = contenido
                        }
                        
                    }else{
                        
                    }
                }
        }
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
