//
//  BienvenidaPaso2TableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class BienvenidaPaso2TableViewController: UITableViewController {
    
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
        
    }
    // MARK: - Actions y Eventos
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider){
        self.edadesLabel.text = "\(Int(rangeSlider.lowerValue))-\(Int(rangeSlider.upperValue))"
    }
    
    func validateAndContinue(){
        /*validacion generos*/
        if(self.hombresSwitch.isOn){
            DataUserDefaults.saveDataBuscoGenero(buscoGenero: 0)
        }
        if(self.mujeresSwitch.isOn){
            DataUserDefaults.saveDataBuscoGenero(buscoGenero: 1)
        }
        if(self.hombresSwitch.isOn && self.mujeresSwitch.isOn){
            DataUserDefaults.saveDataBuscoGenero(buscoGenero: 2)
        }
        if(!(self.hombresSwitch.isOn) && !(self.mujeresSwitch.isOn)){
            DataUserDefaults.saveDataBuscoGenero(buscoGenero: 0)
        }
        /*fumadores*/
        if(self.fumadoresSwitch.isOn){
            DataUserDefaults.saveDataBuscoFuma(buscoFuma: 1)
        }else{
            DataUserDefaults.saveDataBuscoFuma(buscoFuma: 0)
        }
        /*validacion edades*/
        let minEdad = Int(self.rangeSlider.lowerValue)
        let maxEdad = Int(self.rangeSlider.upperValue)
        DataUserDefaults.saveDataBuscoEdadMinima(edad: minEdad)
        DataUserDefaults.saveDataBuscoEdadMaxima(edad: maxEdad)
        
        /*distancia*/
        let distancia = Int(self.distanciaSlider.value)
        DataUserDefaults.saveDataBuscoDistancia(distancia: distancia)
        
        /*relaciones*/
        if(self.amistadSwitch.isOn){
            DataUserDefaults.saveDataBuscoAmistad(relacion: 1)
        }else{
            DataUserDefaults.saveDataBuscoAmistad(relacion: 0)
        }
        if(self.cortoplazoSwitch.isOn){
            DataUserDefaults.saveDataBuscoCortoPlazo(relacion: 1)
        }else{
            DataUserDefaults.saveDataBuscoCortoPlazo(relacion: 0)
        }
        if(self.largoplazoSwitch.isOn){
            DataUserDefaults.saveDataBuscoLargoPlazo(relacion: 1)
        }else{
            DataUserDefaults.saveDataBuscoLargoPlazo(relacion: 0)
        }
        if(self.salirSwitch.isOn){
            DataUserDefaults.saveDataBuscoSalir(relacion: 1)
        }else{
            DataUserDefaults.saveDataBuscoSalir(relacion: 0)
        }
        
        /*Estado civil*/
        if self.solteroSwitch.isOn{
            DataUserDefaults.saveBuscoSoltero(num: 1)
        }else{
            DataUserDefaults.saveBuscoSoltero(num: 0)
        }
        if self.casadoSwitch.isOn{
            DataUserDefaults.saveBuscoCasado(num: 1)
        }else{
            DataUserDefaults.saveBuscoCasado(num: 0)
        }
        if self.divorciadoSwitch.isOn{
            DataUserDefaults.saveBuscoDivorciado(num: 1)
        }else{
            DataUserDefaults.saveBuscoDivorciado(num: 0)
        }
        if self.separadoSwitch.isOn{
            DataUserDefaults.saveBuscoSeparado(num: 1)
        }else{
            DataUserDefaults.saveBuscoSeparado(num: 0)
        }
        if self.unionSwitch.isOn{
            DataUserDefaults.saveBuscoUnionlibre(num: 1)
        }else{
            DataUserDefaults.saveBuscoUnionlibre(num: 0)
        }
        if self.viudoSwitch.isOn{
            DataUserDefaults.saveBuscoViudo(num: 1)
        }else{
            DataUserDefaults.saveBuscoViudo(num: 0)
        }
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
