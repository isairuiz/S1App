//
//  EditarMiPerfil3TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 09/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditarMiperfil3TableViewController:UITableViewController{
    //Generos
    @IBOutlet weak var hombresSwitch: UISwitch!
    @IBOutlet weak var mujeresSwitch: UISwitch!
    
    //Hábitos
    @IBOutlet weak var fumadoresSwitch: UISwitch!
    
    // Edades
    @IBOutlet weak var edadesSliderTableViewCell: UITableViewCell!
    @IBOutlet weak var edadesLabel: UILabel!
    var rangeSlider = RangeSlider()
    
    //Distancia
    @IBOutlet weak var distanciaLabel: UILabel!
    @IBOutlet weak var distanciaSlider: UISlider!
    
    //Lo que busco
    @IBOutlet weak var amistadSwitch: UISwitch!
    @IBOutlet weak var cortoplazoSwitch: UISwitch!
    @IBOutlet weak var largoplazoSwitch: UISwitch!
    @IBOutlet weak var salirSwitch: UISwitch!
    
    //switche's estado civil
    @IBOutlet weak var solteroSwitch: UISwitch!
    @IBOutlet weak var casadoSwitch: UISwitch!
    @IBOutlet weak var divorciadoSwitch: UISwitch!
    @IBOutlet weak var separadoSwitch: UISwitch!
    @IBOutlet weak var unionSwitch: UISwitch!
    @IBOutlet weak var viudoSwitch: UISwitch!
    
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var genero = Int()
    var fuma = Int()
    var MinEdad = Int()
    var MaxEdad = Int()
    var distancia = Int()
    var amistad = Int()
    var cortoPlazo = Int()
    var largoPlazo = Int()
    var salir = Int()
    var soltero = Int()
    var casado = Int()
    var divorciado = Int()
    var separado = Int()
    var union = Int()
    var viudo = Int()
    
    var Changegenero = Int()
    var Changefuma = Int()
    var ChangeMinEdad = Int()
    var ChangeMaxEdad = Int()
    var Changedistancia = Int()
    var Changeamistad = Int()
    var ChangecortoPlazo = Int()
    var ChangelargoPlazo = Int()
    var Changesalir = Int()
    var Changesoltero = Int()
    var Changecasado = Int()
    var Changedivorciado = Int()
    var Changeseparado = Int()
    var Changeunion = Int()
    var Changeviudo = Int()
    
    var busquedaParametros = Parameters()
    var ChangeQueBuscoArray = [String]()
    var ChangeQueDeseoArray = [String]()
    
    var headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.edadesSliderTableViewCell.layoutIfNeeded()
        rangeSlider = RangeSlider(frame: CGRect(x: 32, y: 8, width: self.view.bounds.width - 64 - 58, height: 31  ))
        
        rangeSlider.maximumValue = 99
        rangeSlider.minimumValue = 18
        rangeSlider.lowerValue = 27
        rangeSlider.upperValue = 60
        rangeSlider.trackHighlightTintColor = Colores.MainCTA
        rangeSlider.trackTintColor = Colores.MainKAlpha
        self.edadesSliderTableViewCell.contentView.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(BienvenidaPaso2TableViewController.rangeSliderValueChanged(_:)),
                              for: .valueChanged)
        
        self.setInfo()
        
    }
    // MARK: - Actions y Eventos
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider){
        self.edadesLabel.text = "\(Int(rangeSlider.lowerValue))-\(Int(rangeSlider.upperValue))"
    }
    
    func setInfo(){
        genero = DataUserDefaults.getDataBuscoGenero()
        fuma = DataUserDefaults.getDataBuscoFuma()
        MinEdad = DataUserDefaults.getDataBuscoEdadMinima()
        MaxEdad = DataUserDefaults.getDataBuscoEdadMaxima()
        distancia = DataUserDefaults.getDataBuscoDistancia()
        amistad = DataUserDefaults.getDataBuscoAmistadl()
        cortoPlazo = DataUserDefaults.getDataBuscoCortoPlazol()
        largoPlazo = DataUserDefaults.getDataBuscoLargoPlazo()
        salir = DataUserDefaults.getDataBuscoSalir()
        soltero = DataUserDefaults.getBuscoSoltero()
        casado = DataUserDefaults.getBuscoCasado()
        divorciado = DataUserDefaults.getBuscoDivorciado()
        separado = DataUserDefaults.getBuscoSeparado()
        union = DataUserDefaults.getBuscoUnionlibre()
        viudo = DataUserDefaults.getBuscoViudo()
        
        if genero == 0{
            self.hombresSwitch.isOn = true
        }else if genero == 1{
            self.mujeresSwitch.isOn = true
        }else if genero == 2{
            self.hombresSwitch.isOn = true
            self.mujeresSwitch.isOn = true
        }
        if fuma == 0{
            self.fumadoresSwitch.isOn = false
        }else if fuma == 1{
            self.fumadoresSwitch.isOn = true
        }
        if MinEdad > 0 && MaxEdad > 0{
            self.rangeSlider.upperValue = Double(MaxEdad)
            self.rangeSlider.lowerValue = Double(MinEdad)
            self.edadesLabel.text = "\(MinEdad)-\(MaxEdad)"
        }
        if distancia > 0{
            self.distanciaSlider.value = Float(distancia)
            self.distanciaLabel.text = "\(distancia)m"
        }
        if amistad == 1{
            self.amistadSwitch.isOn = true
        }
        if cortoPlazo == 1{
            self.cortoplazoSwitch.isOn = true
        }
        if largoPlazo == 1{
            self.largoplazoSwitch.isOn = true
        }
        if salir == 1{
            self.salirSwitch.isOn = true
        }
        if soltero == 1{
            self.solteroSwitch.isOn = true
        }
        if casado == 1{
            self.casadoSwitch.isOn = true
        }
        if divorciado == 1{
            self.divorciadoSwitch.isOn = true
        }
        if separado == 1{
            self.separadoSwitch.isOn = true
        }
        if union == 1{
            self.unionSwitch.isOn = true
        }
        if viudo == 1{
            self.viudoSwitch.isOn = true
        }
        
    }
    
    
    func setTempChangesIfNeeded()->Bool{
        /*validacion generos*/
        if(self.hombresSwitch.isOn){
            Changegenero = 0
        }
        if(self.mujeresSwitch.isOn){
            Changegenero = 1
        }
        if(self.hombresSwitch.isOn && self.mujeresSwitch.isOn){
            Changegenero = 2
        }
        if(!(self.hombresSwitch.isOn) && !(self.mujeresSwitch.isOn)){
            
        }
        /*fumadores*/
        if(self.fumadoresSwitch.isOn){
            Changefuma = 1
        }else{
            Changefuma = 0
        }
        /*validacion edades*/
        ChangeMinEdad = Int(self.rangeSlider.lowerValue)
        ChangeMaxEdad = Int(self.rangeSlider.upperValue)
        
        /*distancia*/
        Changedistancia = Int(self.distanciaSlider.value)
        
        /*relaciones*/
        if(self.amistadSwitch.isOn){
            Changeamistad = 1
        }else{
            Changeamistad = 0
        }
        if(self.cortoplazoSwitch.isOn){
            ChangecortoPlazo = 1
        }else{
            ChangecortoPlazo = 0
        }
        if(self.largoplazoSwitch.isOn){
            ChangelargoPlazo = 1
        }else{
            ChangelargoPlazo = 0
        }
        if(self.salirSwitch.isOn){
            Changesalir = 1
        }else{
            Changesalir = 0
        }
        if self.solteroSwitch.isOn{
            Changesoltero = 1
        }else{
            Changesoltero = 0
        }
        if self.casadoSwitch.isOn{
            Changecasado = 1
        }else{
            Changecasado = 0
        }
        if self.divorciadoSwitch.isOn{
            Changedivorciado = 1
        }else{
            Changedivorciado = 0
        }
        if self.separadoSwitch.isOn{
            Changeseparado = 1
        }else{
            Changeseparado = 0
        }
        if self.unionSwitch.isOn{
            Changeunion = 1
        }else{
            Changeunion = 0
        }
        if self.viudoSwitch.isOn{
            Changeviudo = 1
        }else{
            Changeviudo = 0
        }
        
        return true
    }
    
    func lookForLocalChanges()->Bool{
        var changes = String()
        changes = "Cambios:"
        var hasChanged = false
        var hasChangesRelaciones = false
        var hasChangesEstados = false
        if genero != Changegenero{
            hasChanged = true
            changes += "genero,"
            busquedaParametros.updateValue(Changegenero, forKey: "genero")
        }
        if fuma != Changefuma{
            hasChanged = true
            changes += "fumadores,"
            busquedaParametros.updateValue(Changefuma, forKey: "fuma")
        }
        if MinEdad != ChangeMinEdad{
            hasChanged = true
            changes += "min edad,"
            busquedaParametros.updateValue(ChangeMinEdad, forKey: "edad_minima")
        }
        if MaxEdad != ChangeMaxEdad{
            hasChanged = true
            changes += "max edad,"
            busquedaParametros.updateValue(ChangeMaxEdad, forKey: "edad_maxima")
        }
        if distancia != Changedistancia{
            hasChanged = true
            changes += "distancia,"
            busquedaParametros.updateValue(Changedistancia, forKey: "radio")
        }
        if amistad != Changeamistad{
            hasChanged = true
            hasChangesRelaciones = true
            changes += "amistad,"
            ChangeQueDeseoArray.append("1")
        }
        if cortoPlazo != ChangecortoPlazo{
            hasChanged = true
            hasChangesRelaciones = true
            changes += "corto plazo,"
            ChangeQueDeseoArray.append("2")
        }
        if largoPlazo != ChangelargoPlazo{
            hasChanged = true
            hasChangesRelaciones = true
            changes += "largo plazo,"
            ChangeQueDeseoArray.append("3")
        }
        if salir != Changesalir{
            hasChanged = true
            hasChangesRelaciones = true
            changes += "salir,"
            ChangeQueDeseoArray.append("4")
        }
        if soltero != Changesoltero{
            hasChanged = true
            changes += "soltero,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("1")
        }
        if casado != Changecasado{
            hasChanged = true
            changes += "casado,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("2")
        }
        if divorciado != Changedivorciado{
            hasChanged = true
            changes += "divorciado,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("3")
        }
        if separado != Changeseparado{
            hasChanged = true
            changes += "separado,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("4")
        }
        if union != Changeunion{
            hasChanged = true
            changes += "Union,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("5")
        }
        if viudo != Changeviudo{
            hasChanged = true
            changes += "viudo,"
            hasChangesEstados = true
            ChangeQueBuscoArray.append("6")
        }
        //Verifica si se cambio algo en relaciones
        if hasChangesRelaciones{
            debugPrint("Se cambiaron Relaciones:\(ChangeQueDeseoArray)")
            busquedaParametros.updateValue(ChangeQueDeseoArray, forKey: "que_deseo")
            
        }
        //Verifica si se cambio algo en estados civiles
        if hasChangesEstados{
            debugPrint("Se cambiaron Estados:\(ChangeQueBuscoArray)")
            busquedaParametros.updateValue(ChangeQueBuscoArray, forKey: "estado")
        }
        debugPrint(changes)
        return hasChanged
    }
    
    func uploadChanges(){
        self.setLoadingScreen()
        Alamofire.request(Constantes.EDITAR_QUE_BUSCO_URL, method: .put, parameters:busquedaParametros, encoding: URLEncoding.httpBody,headers:self.headers)
            .responseJSON{response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        self.removeLoadingScreen()
                        let alert = UIAlertController(title: "¡Bien!", message: "Tus preferencias de busqueda han sido actualizadas", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            self.getUserData()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        self.removeLoadingScreen()
                        if var message = json["mensaje_plain"].string{
                            debugPrint(message)
                        }
                    }
                }
        }
    }
    
    func getUserData(){
        self.setLoadingScreen()
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
                        self.removeLoadingScreen()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifFinishEditing"), object: nil)
                    }else{
                        
                    }
                }
                
        }
    }

    
    
    private func setLoadingScreen() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 140
        let height: CGFloat = 50
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x:x, y:y, width:width, height:height)
        loadingView.clipsToBounds = true
        loadingView.backgroundColor = Colores.BGPink
        
        // Sets loading text
        self.loadingLabel.textColor = Colores.BGWhite
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Cargando..."
        self.loadingLabel.frame = CGRect(x:0+15, y:0+5, width:150, height:30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.spinner.frame = CGRect(x:0, y:0, width:50, height:50)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        UIApplication.shared.endIgnoringInteractionEvents()
        // Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        self.loadingView.isHidden = true
        
    }
    
    
    
    
    @IBAction func checkHombre(_ sender: Any) {
        if(!(self.hombresSwitch.isOn) && !(self.mujeresSwitch.isOn)){
            self.mujeresSwitch.isOn = true
            
        }
    }
    @IBAction func checkMujer(_ sender: Any) {
        if(!(self.hombresSwitch.isOn) && !(self.mujeresSwitch.isOn)){
            self.hombresSwitch.isOn = true
        }
    }
    
    @IBAction func cambiarDistancia(_ sender: AnyObject) {
        self.distanciaLabel.text = "\(Int(self.distanciaSlider.value))m"
    }
    
    
    
}
