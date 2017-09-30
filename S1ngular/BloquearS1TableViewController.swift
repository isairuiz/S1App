//
//  BloquearS1TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 30/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BloquearS1TableViewController: UITableViewController {

    @IBOutlet weak var razon1Cell: UITableViewCell!
    @IBOutlet weak var razon2Cell: UITableViewCell!
    @IBOutlet weak var razon3Cell: UITableViewCell!
    @IBOutlet weak var razon4Cell: UITableViewCell!
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    var haBloquedo:Bool = false
    var idPersona:Int = DataUserDefaults.getIdVerPerfil()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.razon1Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon1Cell.layer.shadowOpacity = 0.5
        self.razon1Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon1Cell.layer.shadowRadius = 3
        
        self.razon2Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon2Cell.layer.shadowOpacity = 0.5
        self.razon2Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon2Cell.layer.shadowRadius = 3
        
        self.razon3Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon3Cell.layer.shadowOpacity = 0.5
        self.razon3Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon3Cell.layer.shadowRadius = 3
        
        self.razon4Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon4Cell.layer.shadowOpacity = 0.5
        self.razon4Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon4Cell.layer.shadowRadius = 3
    }
    
    
    
    func bloquearUsuario(motivo:Int){
        if Utilerias.isConnectedToNetwork(){
            let lView = UIView()
            let lLabel = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
            let parameters: Parameters = [
                "id_bloqueado": idPersona,
                "motivo": motivo
            ]
            AFManager.request(Constantes.BLOQUEAR_PERFIL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                            if status{
                                if let mensaje = json["mensaje_plain"].string{
                                    self.alertWithMessage(title: "¡Bien!", message: mensaje)
                                }
                            }else{
                                if let errorMessage = json["mensaje_plain"].string{
                                    self.alertWithMessage(title: "¡Algo va mal!", message: errorMessage)
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            
            if indexPath.row == 0{
                self.bloquearUsuario(motivo: 1)
            }
            if indexPath.row == 1{
                self.bloquearUsuario(motivo: 2)
            }
            if indexPath.row == 2{
                self.bloquearUsuario(motivo: 3)
            }
            if indexPath.row == 3{
                self.bloquearUsuario(motivo: 4)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
}
