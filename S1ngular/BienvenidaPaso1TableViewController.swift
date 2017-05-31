//
//  BienvenidaPaso1TableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class BienvenidaPaso1TableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreUsuarioTextField: UITextField!
    @IBOutlet weak var edadTextField: UITextField!
    
    // Género
    @IBOutlet weak var mujerSwitch: UISwitch!
    @IBOutlet weak var hombreSwitch: UISwitch!
    
    // Hábitos
    @IBOutlet weak var fumarSwitch: UISwitch!
    
    //estado
    @IBOutlet weak var solteroSwitch: UISwitch!
    @IBOutlet weak var casadoSwitch: UISwitch!
    @IBOutlet weak var divorciadoSwitch: UISwitch!
    @IBOutlet weak var separadoSwitch: UISwitch!
    @IBOutlet weak var unionLibreSwitch: UISwitch!
    @IBOutlet weak var viudoSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuramos los campos de texto
        self.nombreUsuarioTextField.delegate = self
        self.edadTextField.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        
        

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

    func validateAndContinue(){
        DataUserDefaults.saveDataEdad(edad: self.edadTextField.text!)
        DataUserDefaults.saveDataNombre(nombre: self.nombreUsuarioTextField.text!)
        if(self.mujerSwitch.isOn){
            DataUserDefaults.saveDataGenero(genero: 1)
        }else if(self.hombreSwitch.isOn){
            DataUserDefaults.saveDataGenero(genero: 0)
        }
        if(self.fumarSwitch.isOn){
            DataUserDefaults.saveDataFumo(fumo: true)
        }else{
            DataUserDefaults.saveDataFumo(fumo: false)
        }
        if self.solteroSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 1)
        }
        if self.casadoSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 2)
        }
        if self.divorciadoSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 3)
        }
        if self.separadoSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 4)
        }
        if self.unionLibreSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 5)
        }
        if self.viudoSwitch.isOn{
            DataUserDefaults.saveDataEstado(estado: 6)
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
            self.unionLibreSwitch.isOn = false
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
            self.unionLibreSwitch.isOn = false
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
            self.unionLibreSwitch.isOn = false
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
            self.unionLibreSwitch.isOn = false
            self.viudoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    @IBAction func selectUnion(_ sender: Any) {
        if self.unionLibreSwitch.isOn{
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
            self.unionLibreSwitch.isOn = false
            self.separadoSwitch.isOn = false
        }else{
            self.casadoSwitch.isOn = true
        }
    }
    
}
