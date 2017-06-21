//
//  FotosS1ViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FotosS1ViewController: UIViewController {

    @IBOutlet weak var subtituloView: UIView!
    @IBOutlet weak var subtituloTexto: UILabel!
    var fotitos = Dictionary<String, String>()
    var imageIndex: NSInteger = 0
    @IBOutlet weak var imageContainer: UIImageView!
    
    @IBOutlet weak var inforMessage: UILabel!
    
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var baseUrl = String()
    var idPerfil = Int()
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        // Borramos la line inferior del Navigationbar para que se una al subtitulo
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        idPerfil = DataUserDefaults.getIdVerPerfil()
        
        self.subtituloView.layer.shadowColor = UIColor.black.cgColor
        self.subtituloView.layer.shadowOpacity = 0.5
        self.subtituloView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.subtituloView.layer.shadowRadius = 3
        // Do any additional setup after loading the view.
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
         swipeLeft.direction = UISwipeGestureRecognizerDirection.left
         
         swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
         swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        self.imageContainer.addGestureRecognizer(swipeLeft)
        self.imageContainer.addGestureRecognizer(swipeRight)
        baseUrl = Constantes.BASE_URL
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
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
        
        self.view.insertSubview(view, at:0)
        
    }

    func getUserData(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreenForView(loadingView: loadingView, view: self.view, loadingLabel: loadingLabel, spinner: spinner)
        let finalUrl = "\(Constantes.VER_PERFIL_URL)\(idPerfil)"
        Alamofire.request(finalUrl, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["perfil"]["fotografias"].isEmpty{
                            self.fotitos = json["perfil"]["fotografias"].dictionaryObject as! Dictionary<String, String>
                            debugPrint(self.fotitos)
                            var urlImage = self.baseUrl
                            let urlPrimerFoto = Array(self.fotitos.values)[0]
                            urlImage += urlPrimerFoto
                            self.imageContainer.downloadedFrom(link: urlImage,withBlur:false,maxBlur:0)
                            self.subtituloTexto.text = "\((self.imageIndex+1))/\(self.fotitos.keys.count)"
                            Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        }else{
                            self.inforMessage.isHidden = false
                            debugPrint("No hay fotos para mostrar")
                        }
                    }else{
                        
                    }
                    
                }
                Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
        }
    }
    
    
    
    func respondToSwipeLeft(gesture: UISwipeGestureRecognizer){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        let totalImage = fotitos.keys.count
        self.imageIndex += 1
        if self.imageIndex < totalImage{
            self.fadeOut()
            Utilerias.setCustomLoadingScreenForView(loadingView: loadingView, view: self.view, loadingLabel: loadingLabel, spinner: spinner)
            self.subtituloTexto.text = "\((imageIndex+1))/\(totalImage)"
            var urlImage = self.baseUrl
            let urlFoto = Array(self.fotitos.values)[imageIndex]
            urlImage += urlFoto
            self.downloadedFromURL(link: urlImage,view:loadingView,label:loadingLabel,spinner:spinner)
        }else{
            debugPrint("No hay mas imagenes left")
            self.imageIndex = totalImage
        }
        
    }
    func respondToSwipeRight(gesture: UISwipeGestureRecognizer){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        let totalImage = fotitos.keys.count
        self.imageIndex -= 1
        if self.imageIndex > -1{
            self.fadeOut()
            Utilerias.setCustomLoadingScreenForView(loadingView: loadingView, view: self.view, loadingLabel: loadingLabel, spinner: spinner)
            self.subtituloTexto.text = "\((imageIndex+1))/\(totalImage)"
            var urlImage = self.baseUrl
            let urlFoto = Array(self.fotitos.values)[imageIndex]
            urlImage += urlFoto
            self.downloadedFromURL(link: urlImage,view:loadingView,label:loadingLabel,spinner:spinner)
        }else{
            debugPrint("No hay mas imagenes right")
            self.imageIndex = 0
        }
        
    }
    
    func fadeOut(){
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.imageContainer.alpha = 0.0
        }, completion: nil)
    }
    func fadeIn(){
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.imageContainer.alpha = 1.0
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
 
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
        func downloadedFromURL(url: URL,view:UIView,label:UILabel,spinner:UIActivityIndicatorView) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { () -> Void in
                    self.imageContainer.image = image
                    Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: label, spinner: spinner)
                    self.fadeIn()
                }
                }.resume()
        }
    func downloadedFromURL(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill,view:UIView,label:UILabel,spinner:UIActivityIndicatorView) {
            guard let url = URL(string: link) else { return }
            debugPrint(url)
            downloadedFromURL(url: url,view:view,label:label,spinner:spinner)
        }
    

}

