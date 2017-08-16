//
//  SingleTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 16/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SingleTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var Floating2: UIView!
    @IBOutlet weak var statsButton: UIImageView!
    @IBOutlet weak var imagePerifl: UIImageView!
    @IBOutlet weak var nombrePersona: UILabel!
    @IBOutlet weak var profesionPersona: UILabel!
    @IBOutlet weak var descPersona: UITextView!
    
    
    @IBOutlet weak var lentesButton: UIImageView!
    @IBOutlet weak var afinidadPreview: UILabel!
    @IBOutlet weak var afinidadTotal: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var siButton: UIButton!
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var idVerPerfil = Int()
    var isShowing = false
    var swipeDown = UISwipeGestureRecognizer()
    var swipeUp = UISwipeGestureRecognizer()
    var scrollView = UIScrollView()
    var tapViewLentes = UITapGestureRecognizer()
    var tapViewFloating = UITapGestureRecognizer()
    var tapViewStats = UITapGestureRecognizer()
    
    var childView = TuSingleChildTableViewController()
    
    let jsonPerfilString = DataUserDefaults.getJsonPerfilPersona()
    var jsonPerfilObject : JSON?
    
    var idPerfil:Int = 0
    var urlFotoPerfil:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.delegate = self
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        idVerPerfil = DataUserDefaults.getIdVerPerfil()
        
        tapViewLentes = UITapGestureRecognizer(target: self, action: #selector(self.desBlurFoto(sender:)))
        //tapViewLentes.cancelsTouchesInView = false
        lentesButton.addGestureRecognizer(tapViewLentes)
        
        tapViewFloating = UITapGestureRecognizer(target: self, action: #selector(self.animateFloatingUpDown(sender:)))
        Floating2.addGestureRecognizer(tapViewFloating)
        
        /*let gesture = UIPanGestureRecognizer(target: self, action: #selector(navViewDragged(gesture:)))
        gesture.delegate = self
        
        self.Floating2.addGestureRecognizer(gesture)*/
        
        tapViewStats = UITapGestureRecognizer(target: self, action: #selector(self.showStatsUp(sender:)))
        //tapViewStats.cancelsTouchesInView = false
        statsButton.addGestureRecognizer(tapViewStats)
        
        
        makeLabelRounded(label: self.afinidadPreview)
        makeLabelRounded(label: self.afinidadTotal)
        
        
        
        //self.Floating2.addGestureRecognizer(swipeDown)
        //self.Floating2.addGestureRecognizer(swipeUp)
        
        
        
        self.siButton.layer.cornerRadius = 0.5 * self.siButton.bounds.size.width
        self.siButton.layer.borderColor = Colores.MainCTA.cgColor as CGColor
        self.siButton.layer.borderWidth = 1.0
        self.siButton.clipsToBounds = true
        self.siButton.backgroundColor = Colores.MainCTA
        self.siButton.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.siButton.layer.shadowColor = ColoresTexto.InfoKAlpha.cgColor
        self.siButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.siButton.layer.shadowOpacity = 1.0
        self.siButton.layer.shadowRadius = 3
        self.siButton.layer.masksToBounds = false
        
        self.noButton.layer.cornerRadius = 0.5 * self.noButton.bounds.size.width
        self.noButton.layer.borderColor = Colores.TabBar.cgColor as CGColor
        self.noButton.layer.borderWidth = 1.0
        self.noButton.clipsToBounds = true
        self.noButton.backgroundColor = Colores.TabBar
        self.noButton.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.noButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.noButton.layer.shadowOpacity = 1.0
        self.noButton.layer.shadowRadius = 3
        self.noButton.layer.masksToBounds = false
        
        if let dataFromString = jsonPerfilString.data(using: .utf8, allowLossyConversion: false){
            let loadingView = UIView()
            let spinner = UIActivityIndicatorView()
            let loadingLabel = UILabel()
            Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
            var fotitos = Dictionary<String, String>()
            jsonPerfilObject = JSON(data: dataFromString)
            var jsonAfinidades:[JSON] = []
            var fotoUrl = String()
            if !(self.jsonPerfilObject?["afinidad"].isEmpty)!{
                jsonAfinidades = (self.jsonPerfilObject?["afinidad"].arrayValue)!
                self.childView.setAfinidadesForTable(afinidades: jsonAfinidades)
                for afin in jsonAfinidades{
                    if afin["ambito"].string == "Total"{
                        if let porcent = afin["porcentaje"].int{
                            debugPrint("AFINIDAD TOTAL:\(porcent)")
                            self.afinidadTotal.text = String(porcent)
                            self.afinidadPreview.text = String(porcent)
                        }
                    }
                }
            }
            if !(jsonPerfilObject?["fotografias"].isEmpty)!{
                let foto_visible = jsonPerfilObject?["foto_visible"].floatValue
                fotoUrl += Constantes.BASE_URL
                fotitos = jsonPerfilObject?["fotografias"].dictionaryObject as! Dictionary<String, String>
                fotoUrl += Array(fotitos.values)[0]
                self.urlFotoPerfil = fotoUrl
                self.imagePerifl.downloadedFrom(link: fotoUrl,withBlur:true,maxBlur:foto_visible!)
                
            }
            if let nombre = jsonPerfilObject?["nombre"].string{
                self.nombrePersona.text = nombre
            }
            if let profesion = jsonPerfilObject?["profesion"].string{
                self.profesionPersona.text = profesion
            }
            if let desc = jsonPerfilObject?["sobre_mi"].string{
                self.descPersona.text = desc
            }
            if let id = jsonPerfilObject?["id"].int{
                self.idPerfil = id
            }
            self.tableView.reloadData()
            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
        }
    }
    
    func navViewDragged(gesture: UIPanGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.began ||  gesture.state == UIGestureRecognizerState.changed{
            let translation = gesture.translation(in: self.view)
            debugPrint(gesture.view!.center.y)
            if gesture.view!.center.y < 245+165 && gesture.view!.center.y < 245-165{
                gesture.view!.center = CGPoint(x:gesture.view!.center.x,y:gesture.view!.center.y + translation.y)
            }else{
                gesture.view!.center =  CGPoint(x:gesture.view!.center.x,y:245+165)
            }
            gesture.setTranslation(CGPoint(x:0,y:0), in: self.view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TuSingleChildTableViewController, segue.identifier == "visitarPerfilChildSegue"{
            self.childView = vc
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 330
        }
        else if indexPath.row == 1{
            return UITableViewAutomaticDimension
        }else{
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func desBlurFoto(sender: UITapGestureRecognizer){
        /*Comprar fotografia*/
        
        let alert = UIAlertController(title: "¿Desbloquear foto?", message: "Desbloquea la foto de este s1ngular con 25 S1 Credits.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
            self.tryDesbloquearFoto()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func tryDesbloquearFoto(){
        
        let lView = UIView()
        let lLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
        let parameters: Parameters = ["id": self.idPerfil]
        Alamofire.request(Constantes.COMPRAR_FOTO, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let isVisible = json["foto_visible"].bool{
                            if isVisible{
                                /*quitar el blur de la foto*/
                                self.imagePerifl.downloadedFrom(link: self.urlFotoPerfil,withBlur:false,maxBlur:0.0)
                            }
                            if let mensaje = json["mensaje_plain"].string{
                                self.showAlertWithMessage(title: "¡Espera!", message: mensaje)
                            }
                        }
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let errorMessage = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "¡Algo va mal!", message: errorMessage)
                        }
                    }
                }
        }
    }
    
    
    func animateFloatingUpDown(sender: UITapGestureRecognizer){
        if(isShowing){
            //self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y += (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = false
            })
        }else{
            //self.tableView.isScrollEnabled = false
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
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
            return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func respondToSwipeDown(gesture: UISwipeGestureRecognizer){
        if(isShowing){
            //self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y += (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = false
            })
        }
        
    }
    func respondToSwipeUp(gesture: UISwipeGestureRecognizer){
        if(isShowing==false){
            //self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }
    
    
    func responderS1(respuesta:Int,id:Int){
        let lView = UIView()
        let lLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
        let parameters: Parameters = [
            "id": id,
            "respuesta":respuesta
        ]
        Alamofire.request(Constantes.RESPONDER_S1, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        /*if respuesta == 0{
                            //
                            
                        }else{
                            //self.performSegue(withIdentifier: "gotoYeah", sender: nil)
                        }*/
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let message = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error!", message: message)
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

    // MARK: - Table view data source



    
    @IBAction func aceptarSingular(_ sender: Any) {
        self.responderS1(respuesta:1,id: DataUserDefaults.getIdVerPerfil())
        //self.performSegue(withIdentifier: "gotoYeah", sender: nil)
    }
    
    @IBAction func rechazarSingular(_ sender: Any) {
        self.responderS1(respuesta:0,id: DataUserDefaults.getIdVerPerfil())
        //_ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func makeLabelRounded(label:UILabel){
        label.layer.cornerRadius = 0.5 * label.bounds.size.width
    }

    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
