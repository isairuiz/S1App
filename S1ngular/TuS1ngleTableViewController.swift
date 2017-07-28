//
//  TuS1ngleTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TuS1ngleTableViewController: UITableViewController {
    
    
    @IBOutlet weak var Floating2: UIView!
    @IBOutlet weak var statsButton: UIImageView!
    @IBOutlet weak var imagePerifl: UIImageView!
    @IBOutlet weak var nombrePerfil: UILabel!
    @IBOutlet weak var profesionPerfil: UILabel!
    @IBOutlet weak var sobre_mi: UITextView!
    
    @IBOutlet weak var afinidadTotal: UILabel!

    
    var tapViewLentes = UITapGestureRecognizer()
    var tapViewFloating = UITapGestureRecognizer()
    var tapViewStats = UITapGestureRecognizer()
    var tapViewImagen = UIGestureRecognizer()
    var isShowing = false
    var idPerfil = Int()
    var baseUrl = String()
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var childView = TuSingleChildTableViewController()
    
    var loaderContainer = UIView()
    var loaderLabel = UILabel()
    var spinner = UIActivityIndicatorView()
    
    var fotitos = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idPerfil = DataUserDefaults.getIdVerPerfil()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        tapViewFloating = UITapGestureRecognizer(target: self, action: #selector(self.animateFloatingUpDown(sender:)))
        tapViewFloating.cancelsTouchesInView = false
        Floating2.addGestureRecognizer(tapViewFloating)
        
        tapViewStats = UITapGestureRecognizer(target: self, action: #selector(self.showStatsUp(sender:)))
        tapViewStats.cancelsTouchesInView = false
        statsButton.addGestureRecognizer(tapViewStats)
        
        tapViewImagen = UITapGestureRecognizer(target: self, action: #selector(self.gotoFotosPersona(sender:)))
        tapViewImagen.cancelsTouchesInView = false
        imagePerifl.addGestureRecognizer(tapViewImagen)
        makeLabelRounded(label: afinidadTotal)
        baseUrl = Constantes.BASE_URL
        self.verPerfil()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TuSingleChildTableViewController, segue.identifier == "TuSingleChildSegue"{
            self.childView = vc
        }
    }

    
    
    func verPerfil(){
        Utilerias.setCustomLoadingScreen(loadingView: loaderContainer, tableView: self.tableView, loadingLabel: loaderLabel, spinner: spinner)
        let finalUrl = "\(Constantes.VER_PERFIL_URL)\(idPerfil)"
        debugPrint("final url:\(finalUrl)")
        Alamofire.request(finalUrl, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        if let nombre = json["perfil"]["nombre"].string{
                            self.nombrePerfil.text = nombre
                        }
                        if let genero = json["perfil"]["genero"].int{
                            
                        }
                        if let edad = json["perfil"]["edad"].int{
                            
                        }
                        if let estado = json["perfil"]["estado"].int{
                            
                        }
                        if let hijos = json["perfil"]["hijos"].bool{
                            
                        }
                        if let profesion = json["perfil"]["profesion"].string{
                            self.profesionPerfil.text = profesion
                        }
                        if let fumo = json["perfil"]["fumo"].bool{
                            
                        }
                        if let sombre_mi_text = json["perfil"]["sobre_mi"].string{
                            self.sobre_mi.text = sombre_mi_text
                        }
                        if json["perfil"]["busco"].array != nil{
                            
                        }
                        if json["perfil"]["afinidad"].arrayValue != nil{
                            self.childView.setAfinidadesForTable(afinidades: json["perfil"]["afinidad"].arrayValue)
                        }
                        if !json["perfil"]["fotografias"].isEmpty{
                            self.fotitos = json["perfil"]["fotografias"].dictionaryObject as! Dictionary<String, String>
                            if let idFotoPerfil = json["perfil"]["id_fotografia_perfil"].int{
                                for foto in self.fotitos{
                                    if Int(foto.key) == idFotoPerfil{
                                        var urlImage = self.baseUrl
                                        urlImage += foto.value
                                        self.imagePerifl.downloadedFrom(link: urlImage, withBlur:false,maxBlur:0)
                                    }
                                }
                            }
                            
                            
                        }
                        Utilerias.removeCustomLoadingScreen(loadingView: self.loaderContainer, loadingLabel: self.loaderLabel, spinner: self.spinner)
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: self.loaderContainer, loadingLabel: self.loaderLabel, spinner: self.spinner)
                    }
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoFotosPersona(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoFotosPersona", sender: nil)
    }
    
    func animateFloatingUpDown(sender: UITapGestureRecognizer){
        if(isShowing){
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y += (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = false
            })
        }else{
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }
    
    func showStatsUp(sender: UITapGestureRecognizer){
        if(self.isShowing==false){
            isShowing = true
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
    }
    
    func makeLabelRounded(label:UILabel){
        label.layer.cornerRadius = 0.5 * label.bounds.size.width
    }
    
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source



}
