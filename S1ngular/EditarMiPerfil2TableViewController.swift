//
//  EditarMiPerfil2TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 09/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditarMiPerfil2TableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var edadTextField: UITextField!
    @IBOutlet weak var nombreUsuarioTextField: UITextField!
    
    // Género
    @IBOutlet weak var mujerSwitch: UISwitch!
    @IBOutlet weak var hombreSwitch: UISwitch!
    
    // Hábitos
    @IBOutlet weak var fumarSwitch: UISwitch!
    @IBOutlet weak var solteroSwitch: UISwitch!
    @IBOutlet weak var casadoSwitch: UISwitch!
    @IBOutlet weak var divorciadoSwitch: UISwitch!
    @IBOutlet weak var separadoSwitch: UISwitch!
    @IBOutlet weak var unionSwitch: UISwitch!
    @IBOutlet weak var viudoSwitch: UISwitch!
    
    var nombreUsuario = String()
    var miedad = Int()
    var migenero = Int()
    var fumo = Bool()
    var estadoCivil = Int()
    
    
    var ChangenombreUsuario = String()
    var Changemiedad = Int()
    var ChangemiGenero = Int()
    var ChangeFumo = Bool()
    var ChangeestadoCivil = Int()

    var PerfilParametros = Parameters()
    
    
    var headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuramos los campos de texto
        self.nombreUsuarioTextField.delegate = self
        self.edadTextField.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        
        self.setInfo()
    }
    
    func setInfo(){
        nombreUsuario = DataUserDefaults.getDataNombre()
        miedad = Int(DataUserDefaults.getDataEdad())!
        migenero = DataUserDefaults.getDataGenero()
        fumo = DataUserDefaults.getDataFumo()
        estadoCivil = DataUserDefaults.getDataEstado()
        self.nombreUsuarioTextField.text = nombreUsuario
        self.edadTextField.text = String(miedad)
        if migenero == 0{
            self.hombreSwitch.isOn = true
        }else{
            self.mujerSwitch.isOn = true
        }
        if fumo{
            self.fumarSwitch.isOn = true
        }else{
            self.fumarSwitch.isOn = false
        }
        if estadoCivil == 1{
            self.solteroSwitch.isOn = true
        }else if estadoCivil == 2{
            self.casadoSwitch.isOn = true
        }else if estadoCivil == 3{
            self.divorciadoSwitch.isOn = true
        }else if estadoCivil == 4{
            self.separadoSwitch.isOn = true
        }else if estadoCivil == 5{
            self.unionSwitch.isOn = true
        }else if estadoCivil == 6{
            self.viudoSwitch.isOn = true
        }
    }
    
    func refreshList(notification: NSNotification){
        
        debugPrint("parent method is called")
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nombreUsuarioTextField {
            self.edadTextField.becomeFirstResponder()
        }
        
        if textField == self.edadTextField {
            
            self.view.endEditing(true)
        }
        
        return true
    }
    
    // MARK: - Actions y Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func setTempChangesIfNeeded()->Bool{
        if self.nombreUsuarioTextField.text != ""{
            ChangenombreUsuario = self.nombreUsuarioTextField.text!
        }
        if self.edadTextField.text != ""{
            Changemiedad = Int(self.edadTextField.text!)!
        }
        if self.mujerSwitch.isOn{
            ChangemiGenero = 1
        }
        if self.hombreSwitch.isOn{
            ChangemiGenero = 0
        }
        if self.fumarSwitch.isOn{
            ChangeFumo = true
        }else{
            ChangeFumo = false
        }
        if self.solteroSwitch.isOn{
            ChangeestadoCivil = 1
        }else if self.casadoSwitch.isOn{
            ChangeestadoCivil = 2
        }else if self.divorciadoSwitch.isOn{
            ChangeestadoCivil = 3
        }else if self.separadoSwitch.isOn{
            ChangeestadoCivil = 4
        }else if self.unionSwitch.isOn{
            ChangeestadoCivil = 5
        }else if self.viudoSwitch.isOn{
            ChangeestadoCivil = 6
        }
        return true
        
    }
    
    func lookForLocalChanges()->Bool{
        var changes = String()
        changes = "Cambios:"
        var hasChanged = false
        
        if nombreUsuario != ChangenombreUsuario{
            hasChanged = true
            changes += "Nombre usuario,"
            PerfilParametros.updateValue(ChangenombreUsuario, forKey: "nombre")
        }
        if miedad != Changemiedad{
            hasChanged = true
            changes += "Mi edad,"
            PerfilParametros.updateValue(Changemiedad, forKey: "edad")
        }
        if migenero != ChangemiGenero{
            hasChanged = true
            changes += "Mi genero,"
            PerfilParametros.updateValue(ChangemiGenero, forKey: "genero")
        }
        if fumo != ChangeFumo{
            hasChanged = true
            changes += "Fumo,"
            PerfilParametros.updateValue(ChangeFumo, forKey: "fumo")
        }
        if estadoCivil != ChangeestadoCivil{
            hasChanged = true
            changes += "Estado Civil,"
            PerfilParametros.updateValue(ChangeestadoCivil, forKey: "estado")
            
        }        
        debugPrint(changes)
        return hasChanged
    }
    
    func uploadChanges(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.EDITAR_PERFIL_URL, method: .put, parameters:PerfilParametros, encoding: URLEncoding.httpBody,headers:self.headers)
            .responseJSON{response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        let alert = UIAlertController(title: "¡Bien!", message: "Tu perfil ha sido correctamente actualizado", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            
                            self.getUserData()
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        if var message = json["mensaje_plain"].string{
                            debugPrint(message)
                        }
                    }
                }
        }

    }
    
    func getUserData(){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        Alamofire.request(Constantes.VER_MI_PERFIL_URL, headers: headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if let saldo = json["perfil"]["saldo"].int{
                            debugPrint("saldo:")
                            debugPrint(saldo)
                            DataUserDefaults.setSaldo(saldo: saldo)
                        }
                        if let nombre = json["perfil"]["nombre"].string{
                            debugPrint("nombre:")
                            debugPrint(nombre)
                            DataUserDefaults.saveDataNombre(nombre: nombre)
                        }
                        if let genero = json["perfil"]["genero"].int{
                            debugPrint("genero:")
                            debugPrint(genero)
                            DataUserDefaults.saveDataGenero(genero: genero)
                        }
                        if let edad = json["perfil"]["edad"].int{
                            debugPrint("edad:")
                            debugPrint(edad)
                            DataUserDefaults.saveDataEdad(edad: String(edad))
                        }
                        if let estado = json["perfil"]["estado"].int{
                            debugPrint("estado:")
                            debugPrint(estado)
                            DataUserDefaults.saveDataEstado(estado: estado)
                        }
                        if let prof = json["perfil"]["profesion"].string{
                            debugPrint("profesion:")
                            debugPrint(prof)
                            DataUserDefaults.saveDataProfesion(profesion: prof)
                        }
                        
                        if let fumo = json["perfil"]["fumo"].bool{
                            debugPrint("fumo:")
                            debugPrint(fumo)
                            DataUserDefaults.saveDataFumo(fumo: fumo)
                        }
                        if let bgenero = json["perfil"]["que_busco"]["genero"].int{
                            debugPrint("Busco genero:")
                            debugPrint(bgenero)
                            DataUserDefaults.saveDataBuscoGenero(buscoGenero: bgenero)
                        }
                        if let bedadMinima = json["perfil"]["que_busco"]["edad_minima"].int{
                            debugPrint("Edad minima:")
                            debugPrint(bedadMinima)
                            DataUserDefaults.saveDataBuscoEdadMinima(edad: bedadMinima)
                        }
                        
                        if let bedadMaxima = json["perfil"]["que_busco"]["edad_maxima"].int{
                            debugPrint("Edad Maxima:")
                            debugPrint(bedadMaxima)
                            DataUserDefaults.saveDataBuscoEdadMaxima(edad: bedadMaxima)
                        }
                        if let bdistancia = json["perfil"]["que_busco"]["radio"].int{
                            debugPrint("distancia radio")
                            debugPrint(bdistancia)
                            DataUserDefaults.saveDataBuscoDistancia(distancia: bdistancia)
                        }
                        if let bfuma = json["perfil"]["que_busco"]["fuma"].int{
                            debugPrint("busco fuma:")
                            debugPrint(bfuma)
                            DataUserDefaults.saveDataBuscoFuma(buscoFuma: bfuma)
                        }
                        
                        
                        let estados: Array<JSON> = json["perfil"]["que_busco"]["estado"].arrayValue
                        if estados.count > 0{
                            debugPrint("Busco Estados civiles:")
                            debugPrint(estados)
                            for estado in estados{
                                if estado=="1"{
                                    DataUserDefaults.saveBuscoSoltero(num: 1)
                                }
                                if estado=="2"{
                                    DataUserDefaults.saveBuscoCasado(num: 1)
                                }
                                if estado=="3"{
                                    DataUserDefaults.saveBuscoDivorciado(num: 1)
                                }
                                if estado=="4"{
                                    DataUserDefaults.saveBuscoSeparado(num: 1)
                                }
                                if estado=="5"{
                                    DataUserDefaults.saveBuscoUnionlibre(num: 1)
                                }
                                if estado=="6"{
                                    DataUserDefaults.saveBuscoViudo(num: 1)
                                }
                            }
                        }
                        
                        let que_deseo: Array<JSON> = json["perfil"]["que_busco"]["que_deseo"].arrayValue
                        if que_deseo.count > 0{
                            debugPrint("Que deseo:")
                            debugPrint(que_deseo)
                            for deseo in que_deseo{
                                if deseo == "1"{
                                    DataUserDefaults.saveDataBuscoAmistad(relacion: 1)
                                }
                                if deseo == "2"{
                                    DataUserDefaults.saveDataBuscoCortoPlazo(relacion: 1)
                                }
                                if deseo == "3"{
                                    DataUserDefaults.saveDataBuscoLargoPlazo(relacion: 1)
                                }
                                if deseo == "4"{
                                    DataUserDefaults.saveDataBuscoSalir(relacion: 1)
                                }
                                
                            }
                        }
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifFinishEditPerfil"), object: nil)
                    }else{
                        
                    }
                }
                
        }
    }

    
    @IBAction func seleccionarMujer(_ sender: AnyObject) {
        if self.mujerSwitch.isOn {
            self.hombreSwitch.isOn = false
        } else {
            self.hombreSwitch.isOn = true
        }
        
    }
    @IBAction func seleccionarHombre(_ sender: AnyObject) {
        if self.hombreSwitch.isOn {
            self.mujerSwitch.isOn = false
        } else {
            self.mujerSwitch.isOn = true
        }
    }
    
    //estado acciones switch
    
    @IBAction func selecSoltero(_ sender: Any) {
        if self.solteroSwitch.isOn{
            self.casadoSwitch.isOn = false
            self.divorciadoSwitch.isOn = false
            self.separadoSwitch.isOn = false
            self.unionSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    
    @IBAction func selecCasado(_ sender: Any) {
        if self.casadoSwitch.isOn{
            self.solteroSwitch.isOn = false
            self.divorciadoSwitch.isOn = false
            self.separadoSwitch.isOn = false
            self.unionSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.solteroSwitch.isOn = true
        }
    }
    
    @IBAction func selecDivorciado(_ sender: Any) {
        if self.divorciadoSwitch.isOn{
            self.solteroSwitch.isOn = false
            self.casadoSwitch.isOn = false
            self.separadoSwitch.isOn = false
            self.unionSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    @IBAction func selecSeparado(_ sender: Any) {
        if self.separadoSwitch.isOn{
            self.solteroSwitch.isOn = false
            self.casadoSwitch.isOn = false
            self.divorciadoSwitch.isOn = false
            self.unionSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    @IBAction func selectUnion(_ sender: Any) {
        if self.unionSwitch.isOn{
            self.solteroSwitch.isOn = false
            self.casadoSwitch.isOn = false
            self.divorciadoSwitch.isOn = false
            self.separadoSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    @IBAction func selectViudo(_ sender: Any) {
        if self.viudoSwitch.isOn{
            self.solteroSwitch.isOn = false
            self.casadoSwitch.isOn = false
            self.divorciadoSwitch.isOn = false
            self.unionSwitch.isOn = false
            self.separadoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    
}
