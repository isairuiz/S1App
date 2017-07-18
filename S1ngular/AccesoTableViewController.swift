//
//  AccesoTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class AccesoTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var facebookButton: UIView!
    @IBOutlet weak var facebookButtonLabel: UILabel!
    @IBOutlet weak var fbImage: UIImageView!
    @IBOutlet weak var aceptarButton: UIView!
    @IBOutlet weak var tabLoginViewCell: UITableViewCell!
    
    @IBOutlet weak var aceptarButtonIcon: UIImageView!
    @IBOutlet weak var aceptarButtonLabel: UILabel!
    
    var tab: TabView!
    
    // Campos de texto
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmarPasswordTextfield: UITextField!
    
    // Botones / Celdas
    @IBOutlet weak var facebookTableViewCell: UITableViewCell!
    @IBOutlet weak var aceptarTableViewCell: UITableViewCell!
    @IBOutlet weak var terminosCondicionesTableViewCell: UITableViewCell!
    
    @IBOutlet weak var recuperContraseñaCell: UITableViewCell!
    @IBOutlet weak var buttonRecPass: UIButton!
    
    @IBOutlet weak var terminosSwitch: UISwitch!
    @IBOutlet weak var verTerminosPoliticas: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actIndicatorFB: UIActivityIndicatorView!
    
    var dict : [String : AnyObject]!
    var terminosAceptados:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.layer.shadowColor = UIColor.black.cgColor
        facebookButton.layer.shadowOpacity = 0.5
        facebookButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        facebookButton.layer.shadowRadius = 3
        
        aceptarButton.layer.shadowColor = UIColor.black.cgColor
        aceptarButton.layer.shadowOpacity = 0.5
        aceptarButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        aceptarButton.layer.shadowRadius = 3
        
        self.terminosCondicionesTableViewCell.isHidden = true
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("INICIAR SESIÓN", derecha: "¡REGISTRARME!")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        tabLoginViewCell.addSubview(tab)
        
        // Configuramos los campos de texto
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmarPasswordTextfield.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        let tpVerCondiciones = UITapGestureRecognizer(target: self, action: #selector(self.modalTerminosPoliticas(_:)))
        self.verTerminosPoliticas.addGestureRecognizer(tpVerCondiciones)
        
        let tapFacebook = UITapGestureRecognizer(target: self, action: #selector(self.facebookButtonTap(_:)))
        self.facebookTableViewCell.addGestureRecognizer(tapFacebook   )
        
        let tapAceptar = UITapGestureRecognizer(target: self, action: #selector(self.aceptarButtonTap(_:)))
        self.aceptarTableViewCell.addGestureRecognizer(tapAceptar   )
        
        
        let tapViewRecPass = UITapGestureRecognizer(target: self, action:#selector(self.recuperarPassword(_:)))
        self.buttonRecPass.addGestureRecognizer(tapViewRecPass)
        
        self.tableView.layoutIfNeeded()
        
        if(DataUserDefaults.isLoggedIn()){
            let currentEmail = DataUserDefaults.getCurrentEmail()
            let currentPass = DataUserDefaults.getCurrentPassword()
            if((currentEmail.isEmpty) || (currentPass.isEmpty)){
                debugPrint("No hay cuenta para iniciar sesion")
            }else{
                self.showActIndicatorFB()
                self.loginToSingular(mail: currentEmail,password: currentPass)
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "MainBG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        
    }
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        
        if textField == self.passwordTextField {
            
            if self.tab.tabSeleccionada == 0 {
                self.view.endEditing(true)
                // Iniciar sesión
            } else {
                self.confirmarPasswordTextfield.becomeFirstResponder()
            }
        }
        if textField == self.confirmarPasswordTextfield {
            
            self.view.endEditing(true)
            // Registrar
        }
        
        return true
    }

    // MARK: - Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    func modalTerminosPoliticas(_ sender: UITapGestureRecognizer){
        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Ver Politicas de Privacidad", style: .default, handler: { (action: UIAlertAction!) in
            
            let url = URL(string: "http://40.84.231.88/singular/admin/privacidad")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Ver Términos y Condiciones", style: .default, handler: { (action: UIAlertAction!) in
            let url = URL(string: "http://40.84.231.88/singular/admin/terminos")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func recuperarPassword(_ sender: UITapGestureRecognizer){
        debugPrint("Dandole a recuperar")
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Recuperación de contraseña", message: "Ingrese su correo para recuperar su contraseña.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Correo"
        }
        
        alert.addAction(UIAlertAction(title: "Recuperar", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let mail:String = (textField?.text)!
            if !(mail.isEmpty){
                self.RecuperarPassword(correo: mail)
            }else{
                self.showAlerWithMessage(title: "Error", message: "Ingresa tu corre por favor.")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func cambiarPrimerTab (){
        
        self.terminosCondicionesTableViewCell.isHidden = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        // Cambiamos el return key de password para que funcione como enter
        self.passwordTextField.returnKeyType = .join
        
        
        // Cambiamos el texto e icono del boton Signin/Signup
        self.aceptarButtonIcon.image = UIImage(named: "Login")
        self.aceptarButtonLabel.text = "ENTRAR"
        
        // Hack para los campos que se van a ocultar y no haga un efecto feo
        self.tableView.cellForRow(at: IndexPath(row: 9, section: 0))?.isHidden =  true
        self.tableView.cellForRow(at: IndexPath(row: 11, section: 0))?.isHidden =  false
        
    }
    
    func cambiarSegundoTab (){
        self.terminosCondicionesTableViewCell.isHidden = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        // Cambiamos el return key de password para que funcione como enter
        self.passwordTextField.returnKeyType = .next
        
        // Cambiamos el texto e icono del boton Signin/Signup
        self.aceptarButtonIcon.image = UIImage(named: "Ok")
        self.aceptarButtonLabel.text = "ENVIAR"
        
        // Hack para los campos que se van a ocultar y no haga un efecto feo
        self.tableView.cellForRow(at: IndexPath(row: 9, section: 0))?.isHidden =  false
        self.tableView.cellForRow(at: IndexPath(row: 11, section: 0))?.isHidden =  true
    }
    
    func showActivityIndicatory() {
        
        aceptarButtonLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator(){
        aceptarButtonLabel.isHidden = false
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func showActIndicatorFB(){
        facebookButtonLabel.isHidden = true
        fbImage.isHidden = true
        actIndicatorFB.isHidden = false
        actIndicatorFB.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActIndicatorFB(){
        facebookButtonLabel.isHidden = false
        fbImage.isHidden = false
        actIndicatorFB.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func showAlerWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearFields(){
        self.passwordTextField.text = ""
        self.confirmarPasswordTextfield.text = ""
    }
    
    
    func aceptarButtonTap(_ sender: UITapGestureRecognizer){
        //self.performSegue(withIdentifier: "MostrarApp", sender: self)
        if self.tab.tabSeleccionada == 0 {
            //Iniciar Sesion
            
            let mail = self.emailTextField.text
            let password = self.passwordTextField.text
            
            if((mail?.isEmpty)! || (password?.isEmpty)!){
                showAlerWithMessage(title: "Error", message: "Todos los campos son requeridos")
            }else{
                self.showActivityIndicatory()
                self.loginToSingular(mail: mail!,password: password!)

            }
            
        } else {
            //Registro
            let mail = self.emailTextField.text
            let password = self.passwordTextField.text
            let repeatPass = self.confirmarPasswordTextfield.text
            let equalPass = (repeatPass == password)
            if((mail?.isEmpty)! || (password?.isEmpty)!){
                showAlerWithMessage(title: "Error", message: "Todos los campos son requeridos")
            }else{
                if(equalPass){
                    if self.terminosAceptados{
                    self.showActivityIndicatory()
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                            multipartFormData.append((mail?.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "mail")
                            multipartFormData.append((password?.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "password")
                    },
                        to: Constantes.REGISTER_URL,
                        encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    let json = JSON(response.result.value)
                                    debugPrint(json)
                                    if let status = json["status"].bool {
                                        debugPrint(status)
                                        if (status){
                                            if let idUsuario = json["id"].string{
                                                DataUserDefaults.setCurrentId(id: Int(idUsuario)!)
                                            }
                                            if var message = json["mensaje_plain"].string{
                                                message+=" Por favor inicia sesión."
                                                self.showAlerWithMessage(title:"Bien",message: message)
                                                self.clearFields()
                                                self.hideActivityIndicator()
                                                self.tab.botonIzquierda?.sendActions(for: .touchUpInside)
                                            }
                                        }else{
                                            if let message = json["mensaje_plain"].string{
                                                self.hideActivityIndicator()
                                                self.showAlerWithMessage(title:"Error",message: message)
                                            }
                                        }
                                    }
                                    
                                }
                                
                            case .failure(let encodingError):
                                
                                print(encodingError)
                            }
                    }
                    )
                    }else{
                        showAlerWithMessage(title:"Error",message: "Debes estar de acuerdo con las Politicas de Privacidad y con los Terminos y Condiciones para poder continuar.")
                    }
                }else{
                    showAlerWithMessage(title:"Error",message: "Las contraseñas no coinciden")
                }
            }
            
        }
 
    }
    
    
    
    func facebookButtonTap(_ sender: UITapGestureRecognizer){
        self.showActIndicatorFB()
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }else{
                debugPrint("Algun error")
                debugPrint(error)
            }
        }
        
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    let json = JSON(object: self.dict)
                    print(json)
                    if let urlImage = json["picture"]["data"]["url"].string {
                        DataUserDefaults.setFBUrlImage(url: urlImage)
                        debugPrint(urlImage)
                    }
                    if let fbid = json["id"].string{
                        DataUserDefaults.setFBId(fbid: fbid)
                        debugPrint(fbid)
                        let email = json["email"].string
                        DataUserDefaults.setFBEmail(email: email!)
                        self.FBLoginSingular(fbid: fbid, email: email!)
                    }
                }
            })
        }
    }
    
    func loginToSingular(mail:String, password:String){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append((mail.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "mail")
                multipartFormData.append((password.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "password")
        },
            to: Constantes.LOGIN_URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool {
                            if (status){
                                if let idSingular = json["id"].int{
                                    DataUserDefaults.setCurrentId(id: idSingular)
                                }
                                if let authtoken = json["token"].string{
                                    DataUserDefaults.setUserToken(token: authtoken)
                                    DataUserDefaults.setUserData(email: mail, user: "", password: password)
                                    DataUserDefaults.setIsLogged(logged: true)
                                    
                                }
                                /*Descomntar para produccion*/
                                if let primerLogin = json["primerlogin"].bool{
                                    if(primerLogin){
                                        self.performSegue(withIdentifier: "MostrarBienvenida", sender: self)
                                    }else{
                                        self.performSegue(withIdentifier: "MostrarApp", sender: self)
                                    }
                                    self.hideActivityIndicator()
                                    self.hideActIndicatorFB()
                                    
                                }
                                self.hideActivityIndicator()
                                self.hideActIndicatorFB()
                            }else{
                                if let message = json["mensaje_plain"].string{
                                    self.hideActIndicatorFB()
                                    self.hideActivityIndicator()
                                    self.showAlerWithMessage(title:"Error",message: message)
                                    
                                }
                            }
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    self.hideActIndicatorFB()
                    self.hideActivityIndicator()
                    print(encodingError)
                }
        }
        )
    }

    func FBLoginSingular(fbid:String,email:String){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append((email.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "mail")
                multipartFormData.append((fbid.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "facebook_id")
        },
            to: Constantes.LOGIN_URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool {
                            debugPrint(status)
                            if (status){
                                
                                if let idSingular = json["id"].int{
                                    DataUserDefaults.setCurrentId(id: idSingular)
                                }
                                if let authtoken = json["token"].string{
                                    debugPrint(authtoken)
                                    DataUserDefaults.setUserToken(token: authtoken)
                                    DataUserDefaults.setUserData(email: email, user: "", password:"")
                                    DataUserDefaults.setIsLogged(logged: true)
                                    
                                }
                                self.performSegue(withIdentifier: "MostrarBienvenida", sender: self)
                                
                                /*Descomntar para produccion*/
                                if let primerLogin = json["primerlogin"].bool{
                                 debugPrint(primerLogin)
                                 if(primerLogin){
                                 self.performSegue(withIdentifier: "MostrarBienvenida", sender: self)
                                 }else{
                                 self.performSegue(withIdentifier: "MostrarApp", sender: self)
                                 }
                                 self.hideActivityIndicator()
                                 
                                 }
                                self.hideActIndicatorFB()
                            }else{
                                if let message = json["mensaje_plain"].string{
                                    self.hideActIndicatorFB()
                                    self.showAlerWithMessage(title:"Error",message: message)
                                }
                            }
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    self.hideActIndicatorFB()
                    print(encodingError)
                }
        }
        )
    
    }
    
    func RecuperarPassword(correo:String){
        let lView = UIView()
        let lLabel = UILabel()
        let spinner = UIActivityIndicatorView()
        Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
        let parameters: Parameters = ["mail": correo]
        Alamofire.request(Constantes.RECUPERAR_PASS, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let mensaje = json["mensaje_plain"].string{
                            self.showAlerWithMessage(title: "Bien!", message: mensaje)
                        }
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                        if let mensaje = json["mensaje_plain"].string{
                            self.showAlerWithMessage(title: "Bien!", message: mensaje)
                        }
                    }
                }
        }
    }
    
    
    // MARK: - Action
    
    
    
    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        // Logo
        if indexPath.row == 0 {
            return 130
        }
        // Slogan y delimitador "o"
        if indexPath.row == 1 || indexPath.row == 5 {
            return 44
        }
        
        // Espacio y slogan de facebook
        if indexPath.row == 2 || indexPath.row == 4 {
            return 22
        }
        
        // Facebook y Signin Button
        if indexPath.row == 3 || indexPath.row == 10{
            return 78
        }
        
        // Tab Signin/Signup
        if indexPath.row == 6 {
            return 66
        }
        
        // Email y  Password Signin
        if indexPath.row == 7 || indexPath.row == 8  {
            return 66
        }
        
       
        
        // Confirmar Password Signup
        if indexPath.row == 9 && self.tab.tabSeleccionada == 1 {
            return 66
        }
        
        if indexPath.row == 9 && self.tab.tabSeleccionada == 0 {
            return 0
        }
        
        // Olvide contraseña
        if indexPath.row == 11 && self.tab.tabSeleccionada == 0 {
            return 44
        }
        
        if indexPath.row == 11 && self.tab.tabSeleccionada == 1 {
            return 0
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 3 || indexPath.row == 10 || indexPath.row == 12 {
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
    

    @IBAction func switchTerminosChange(_ sender: Any) {
        if self.terminosSwitch.isOn{
            self.terminosAceptados = true
        }else{
            self.terminosAceptados = false
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
