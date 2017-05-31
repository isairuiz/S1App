//
//  BienvenidaPaso4ViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 01/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BienvenidaPaso4ViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var subtituloView: UIView!

    @IBOutlet weak var homeWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHomePointLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var s1ngularesHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var s1ngularesLeftLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var testsLeftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var testsHeightLayoutConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var checkInLeftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkInHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var masHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMasPointLayoutConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var homePointView: UIView!
    @IBOutlet weak var s1ngularesPointView: UIView!
    @IBOutlet weak var testsPointView: UIView!
    @IBOutlet weak var checkInPointView: UIView!
    @IBOutlet weak var masPointView: UIView!
    
    @IBOutlet weak var homeLineView: UIView!
    @IBOutlet weak var s1ngularesLineView: UIView!
    @IBOutlet weak var testsLineView: UIView!
    @IBOutlet weak var checkInLineView: UIView!
    @IBOutlet weak var masLineView: UIView!
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var s1ngularesLabel: UILabel!
    @IBOutlet weak var testsLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var masLabel: UILabel!
    
    @IBOutlet weak var homeTip: UIImageView!
    @IBOutlet weak var s1ngularesTip: UIImageView!
    @IBOutlet weak var testsTip: UIImageView!
    @IBOutlet weak var checkInTip: UIImageView!
    @IBOutlet weak var masTip: UIImageView!
    
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var s1ngularesTabBarItem: UITabBarItem!
    @IBOutlet weak var testsTabBarItem: UITabBarItem!
    @IBOutlet weak var checkInTabBarItem: UITabBarItem!
    @IBOutlet weak var masTabBarItem: UITabBarItem!
    
    @IBOutlet weak var finalizarBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var banderaS1ngulares = false
    var banderaTests = false
    var banderaCheckIn = false
    var banderaMas = false
    var headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        // Borramos la line inferior del Navigationbar para que se una al subtitulo
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.subtituloView.layer.shadowColor = UIColor.black.cgColor
        self.subtituloView.layer.shadowOpacity = 0.5
        self.subtituloView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.subtituloView.layer.shadowRadius = 3
        
        // Configuramos el tabbar
        self.tabBar.selectedItem = self.homeTabBarItem
        self.tabBar.delegate = self
        
        // Configuramos el grid del minitour
        
        let anchoItemBar = self.view.bounds.width / 5
        let top = self.view.bounds.height - 49 - 44 - 57 - 40
        
        self.homeHeightLayoutConstraint.constant =  top
        self.leftHomePointLayoutConstraint.constant = (anchoItemBar / 2 ) - 6
        
        self.s1ngularesHeightLayoutConstraint.constant =  top - 90
        self.s1ngularesLeftLayoutConstraint.constant = anchoItemBar * 2 - anchoItemBar / 2 - 150 / 2
        
        self.testsHeightLayoutConstraint.constant =  top - 90 - 90
        self.testsLeftLayoutConstraint.constant = anchoItemBar * 3 - anchoItemBar / 2 - 150 / 2
        
        self.checkInHeightLayoutConstraint.constant =  top - 90 - 90 - 90
        self.checkInLeftLayoutConstraint.constant = anchoItemBar * 4 - anchoItemBar / 2 - 150 / 2
        
        self.masHeightLayoutConstraint.constant =  top - 50
        self.rightMasPointLayoutConstraint.constant = (anchoItemBar / 2 ) - 6
        
        // Redondeamos los punteros
        
        self.homePointView.layoutIfNeeded()
        self.homePointView.layer.cornerRadius = self.homePointView.bounds.height / 2
        
        self.s1ngularesPointView.layoutIfNeeded()
        self.s1ngularesPointView.layer.cornerRadius = self.s1ngularesPointView.bounds.height / 2
        
        self.testsPointView.layoutIfNeeded()
        self.testsPointView.layer.cornerRadius = self.testsPointView.bounds.height / 2
        
        self.checkInPointView.layoutIfNeeded()
        self.checkInPointView.layer.cornerRadius = self.checkInPointView.bounds.height / 2
        
        self.masPointView.layoutIfNeeded()
        self.masPointView.layer.cornerRadius = self.masPointView.bounds.height / 2
        
        // Configuramos las lineas punteadas
        
        self.crearLineaPunteada(lineView: homeLineView)
        self.crearLineaPunteada(lineView: s1ngularesLineView)
        self.crearLineaPunteada(lineView: testsLineView)
        self.crearLineaPunteada(lineView: checkInLineView)
        self.crearLineaPunteada(lineView: masLineView)
        
        // Configuramos el texto para estar igual a los mockups
        
        
        let homeText = NSMutableAttributedString(string: "Este es el ", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        let homeText2 = NSMutableAttributedString(string: "centro de navegacion", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 15)! ])
        let homeText3 = NSMutableAttributedString(string: " de ", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        let homeText4 = NSMutableAttributedString(string: "S1", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 15)! ])
        
        homeText.append(homeText2)
        homeText.append(homeText3)
        homeText.append(homeText4)
        
        self.homeLabel.attributedText = homeText;
        
        
        let s1ngularesText = NSMutableAttributedString(string: "Conecta", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 14.5)!])
        let s1ngularesText2 = NSMutableAttributedString(string: " con s1ngulares que quieren conocerte", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 14.5)! ])
        
        s1ngularesText.append(s1ngularesText2)
        
        self.s1ngularesLabel.attributedText = s1ngularesText;
        
        
        let testsText = NSMutableAttributedString(string: "Conócete y comparte", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 14.5)!])
        let testsText2 = NSMutableAttributedString(string: " tests con tus amigos", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 14.5)! ])
        
        testsText.append(testsText2)
        
        self.testsLabel.attributedText = testsText;
        
        
        let checkInText = NSMutableAttributedString(string: "Haz ", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        let checkInText2 = NSMutableAttributedString(string: "Check In", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 15)! ])
        let checkInText3 = NSMutableAttributedString(string: " y conoce s1ngulares", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        
        checkInText.append(checkInText2)
        checkInText.append(checkInText3)
        
        self.checkInLabel.attributedText = checkInText;
        
        
        let masText = NSMutableAttributedString(string: "Edita y realiza ", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        let masText2 = NSMutableAttributedString(string: "ajustes", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Black", size: 15)! ])
        let masText3 = NSMutableAttributedString(string: " en tu cuenta", attributes: [NSFontAttributeName :  UIFont(name: "BrandonGrotesque-Medium", size: 15)!])
        
        masText.append(masText2)
        masText.append(masText3)
        
        self.masLabel.attributedText = masText;
        
        // Ocultamos las descripciones y subimos un poco los layouts para darle un efecto de caida cuando sean visibles
        
        self.s1ngularesLabel.alpha = 0
        self.s1ngularesLineView.alpha = 0
        self.s1ngularesPointView.alpha = 0
        self.s1ngularesTip.alpha = 0
        self.s1ngularesHeightLayoutConstraint.constant += 20
        
        self.testsLabel.alpha = 0
        self.testsLineView.alpha = 0
        self.testsPointView.alpha = 0
        self.testsTip.alpha = 0
        self.testsHeightLayoutConstraint.constant += 20
        
        self.checkInLabel.alpha = 0
        self.checkInLineView.alpha = 0
        self.checkInPointView.alpha = 0
        self.checkInTip.alpha = 0
        self.checkInHeightLayoutConstraint.constant += 20
        
        self.masLabel.alpha = 0
        self.masLineView.alpha = 0
        self.masPointView.alpha = 0
        self.masTip.alpha = 0
        self.masHeightLayoutConstraint.constant += 20
        
        // Deshabilitamos el boton de finalizar Tour
        
        self.finalizarBarButtonItem.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "MainBG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.view.insertSubview(imageView, at: 0)
        
    }
    // MARK: - Actions y Eventos
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showActivityIndicatory() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func processDataForEditarPerfil(){
        self.showActivityIndicatory()
        let nombre = DataUserDefaults.getDataNombre()
        let genero = DataUserDefaults.getDataGenero()
        let edad = DataUserDefaults.getDataEdad()
        let estado = DataUserDefaults.getDataEstado()
        let profesion = DataUserDefaults.getDataProfesion()
        let fumo = DataUserDefaults.getDataFumo()
        let sobre_mi = DataUserDefaults.getDataSobreMi()
        
        let parametersPerfil: Parameters = [
            "nombre": nombre,
            "genero": genero,
            "edad": edad,
            "estado":estado,
            "profesion":profesion,
            "fumo":fumo,
            "sobre_mi":sobre_mi
        ]
        
        Alamofire.request(Constantes.EDITAR_PERFIL_URL, method: .put, parameters:parametersPerfil, encoding: URLEncoding.httpBody,headers:self.headers)
            .responseJSON{response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if var message = json["mensaje_plain"].string{
                            let alert = UIAlertController(title: "¡Bien!", message: "Los datos de tu perfil han sido actualizados", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
                                self.processDataForEditarQueBusco()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        
                        if var message = json["mensaje_plain"].string{
                            self.showAlerWithMessage(title: "Error!", message: message)
                        }
                        self.hideActivityIndicator()
                    }
                    
                }
        }
        
    }
    func processDataForEditarQueBusco(){
        var estados_busco_array = [String]()
        var que_deseo_array = [String]()
        let busco_genero = DataUserDefaults.getDataBuscoGenero()
        let edad_maxima = DataUserDefaults.getDataBuscoEdadMaxima()
        let edad_minima = DataUserDefaults.getDataBuscoEdadMinima()
        let busco_radio = DataUserDefaults.getDataBuscoDistancia()
        let busco_fuma = DataUserDefaults.getDataBuscoFuma()
        //estados civiles
        let busco_soltero = DataUserDefaults.getBuscoSoltero()
        let busco_casado = DataUserDefaults.getBuscoCasado()
        let busco_divorciado = DataUserDefaults.getBuscoDivorciado()
        let busco_separado = DataUserDefaults.getBuscoSeparado()
        let busco_union = DataUserDefaults.getBuscoUnionlibre()
        let busco_viudo = DataUserDefaults.getBuscoViudo()
        //evaluar estados civiles
        if busco_soltero == 1{
            estados_busco_array.append("1")
        }
        if busco_casado == 1{
            estados_busco_array.append("2")
        }
        if busco_divorciado == 1{
            estados_busco_array.append("3")
        }
        if busco_separado == 1{
            estados_busco_array.append("4")
        }
        if busco_union == 1{
            estados_busco_array.append("5")
        }
        if busco_viudo == 1{
            estados_busco_array.append("6")
        }
        let estados_busco_string = estados_busco_array.description
        //QUE DESEO RELACIONES
        let busco_amistad = DataUserDefaults.getDataBuscoAmistadl()
        let busco_corto_plazo = DataUserDefaults.getDataBuscoCortoPlazol()
        let busco_largo_plazo = DataUserDefaults.getDataBuscoLargoPlazo()
        let busco_salir = DataUserDefaults.getDataBuscoSalir()
        //EVALUAR DESEO RELACIONES
        if busco_amistad == 1{
            que_deseo_array.append("1")
        }
        if busco_corto_plazo == 1{
            que_deseo_array.append("2")
        }
        if busco_largo_plazo == 1{
            que_deseo_array.append("3")
        }
        if busco_salir == 1{
            que_deseo_array.append("4")
        }
        let que_deseo_string = que_deseo_array.description
        
        let parametersPerfil: Parameters = [
            "genero": busco_genero,
            "edad_maxima": edad_maxima,
            "edad_minima": edad_minima,
            "estado": estados_busco_array,
            "que_deseo": que_deseo_array,
            "radio": busco_radio,
            "fuma": busco_fuma
        ]
        
        Alamofire.request(Constantes.EDITAR_QUE_BUSCO_URL, method: .put, parameters:parametersPerfil, encoding: URLEncoding.httpBody,headers:self.headers)
            .responseJSON{response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        let photo = DataUserDefaults.getDataFoto()
                        let noFoto = photo.count<=0
                        var buttonTitle = String()
                        buttonTitle = "Un paso mas"
                        if(noFoto){
                            buttonTitle = "Ir a home"
                        }
                        if var message = json["mensaje_plain"].string{
                            let alert = UIAlertController(title: "¡Bien!", message: "Tus preferencias de busqueda han sido actualizadas", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: { action in
                                if(noFoto){
                                    self.performSegue(withIdentifier: "passToMenuSegue", sender: nil)
                                }else{
                                    self.processDataAgregarFoto()
                                }
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        if var message = json["mensaje_plain"].string{
                            self.showAlerWithMessage(title: "Error!", message: message)
                        }
                        self.hideActivityIndicator()
                    }
                }
        }
    }
    
    func processDataAgregarFoto(){
        var imageName = "image"+Utilerias.getCurrentDateAndTime()+".jpeg"
        var photo = Data()
        photo = DataUserDefaults.getDataFoto()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(photo, withName: "imagen", fileName: imageName, mimeType: "image/jpeg")
        },
            to: Constantes.AGREGAR_FOTO, headers:self.headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool {
                            if (status){
                                let alert = UIAlertController(title: "¡Bien!", message: "Has agregado una foto, la usaremos para tu foto de perfil", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ir a home", style: UIAlertActionStyle.default, handler: { action in
                                    self.performSegue(withIdentifier: "passToMenuSegue", sender: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if let message = json["mensaje_plain"].string{
                                    self.hideActivityIndicator()
                                    self.showAlerWithMessage(title:"Error",message: message)
                                }
                                self.hideActivityIndicator()
                            }
                        }else{
                            self.hideActivityIndicator()
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    self.hideActivityIndicator()
                    print(encodingError)
                    self.hideActivityIndicator()
                }
        }
        )

        
    }
    
    func showAlerWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func finalizarTour(_ sender: AnyObject) {
        let alert = UIAlertController(title: "¿Desea continuar?", message: "Presione continuar para guardar los datos de perfil, preferencias de busqueda y foto de lo contrario presione cancelar para verificar su información", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
            self.processDataForEditarPerfil()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Funciones personalizadas
    func crearLineaPunteada(lineView: UIView){
        lineView.layoutIfNeeded()
        lineView.backgroundColor = UIColor.clear
        lineView.clipsToBounds = true
        var i = 0
        while i < Int(lineView.bounds.height) {
            let view = UIView(frame: CGRect(x: 0, y: i, width: 2, height: 2))
            view.backgroundColor = UIColor.white
            lineView.addSubview(view)
            i += 5
        }
    }
    
    // MARK: - Tabbar
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == self.s1ngularesTabBarItem && self.s1ngularesLabel.alpha == 0 {
            
            self.banderaS1ngulares = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.s1ngularesLabel.alpha = 1
                self.s1ngularesLineView.alpha = 1
                self.s1ngularesPointView.alpha = 1
                self.s1ngularesTip.alpha = 1
                self.s1ngularesHeightLayoutConstraint.constant -= 20
                self.view.layoutIfNeeded()
            })
            
        }
        
        if item == self.testsTabBarItem && self.testsLabel.alpha == 0 {
            
            self.banderaTests = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.testsLabel.alpha = 1
                self.testsLineView.alpha = 1
                self.testsPointView.alpha = 1
                self.testsTip.alpha = 1
                self.testsHeightLayoutConstraint.constant -= 20
                self.view.layoutIfNeeded()
            })

        }
        
        if item == self.checkInTabBarItem && self.checkInLabel.alpha == 0 {
            
            self.banderaCheckIn = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.checkInLabel.alpha = 1
                self.checkInLineView.alpha = 1
                self.checkInPointView.alpha = 1
                self.checkInTip.alpha = 1
                self.checkInHeightLayoutConstraint.constant -= 20
                self.view.layoutIfNeeded()
            })
            
        }
        
        if item == self.masTabBarItem && self.masLabel.alpha == 0 {
            
            self.banderaMas = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.masLabel.alpha = 1
                self.masLineView.alpha = 1
                self.masPointView.alpha = 1
                self.masTip.alpha = 1
                self.masHeightLayoutConstraint.constant -= 20
                self.view.layoutIfNeeded()
            })

        }
        
        if banderaS1ngulares && banderaTests && banderaCheckIn && banderaMas {
            self.finalizarBarButtonItem.isEnabled = true
        }
    }

}
