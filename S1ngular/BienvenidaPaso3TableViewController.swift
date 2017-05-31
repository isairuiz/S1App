//
//  BienvenidaPaso3TableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class BienvenidaPaso3TableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profesionTextField: UITextField!
    @IBOutlet weak var sobreTiTextField: UITextField!
    
    @IBOutlet weak var fotoTapView: UIVisualEffectView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var fotoDifuminada: UIImageView!
    
    @IBOutlet weak var quitarFotoButton: UIButton!
    @IBOutlet weak var camaraButton: UIButton!
    
    @IBOutlet weak var fotoFooterView: UIVisualEffectView!
    @IBOutlet weak var fotoFooterLabel: UILabel!
    
    var imageData = Data()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuramos los campos de texto
        self.profesionTextField.delegate = self
        self.sobreTiTextField.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        let tapFoto = UITapGestureRecognizer(target: self, action: #selector(self.tomarFoto(_:)))
        self.fotoTapView.addGestureRecognizer(tapFoto)
        
        self.tableView.layoutIfNeeded()
        
        self.fotoFooterView.isHidden = true
        
        self.quitarFotoButton.layoutIfNeeded()
        self.camaraButton.layoutIfNeeded()
        
        self.quitarFotoButton.layer.cornerRadius = self.quitarFotoButton.bounds.height / 2
        self.camaraButton.layer.cornerRadius = self.camaraButton.bounds.height / 2
        
        quitarFotoButton.layer.shadowColor = UIColor.black.cgColor
        quitarFotoButton.layer.shadowOpacity = 0.5
        quitarFotoButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        quitarFotoButton.layer.shadowRadius = 3
        
        camaraButton.layer.shadowColor = UIColor.black.cgColor
        camaraButton.layer.shadowOpacity = 0.5
        camaraButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        camaraButton.layer.shadowRadius = 3
        
        self.quitarFotoButton.isHidden = true
        self.camaraButton.isHidden = true
        
        self.fotoDifuminada.isHidden = true
        
        
    }
    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Esto es para que la vista de la foto sea cuadrada dependiendo del ancho del dispositivo
        if indexPath.row == 0 {
            return self.view.bounds.width
        }
        if indexPath.row == 1 {
            return 22
        }
        return 66
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.profesionTextField {
            self.sobreTiTextField.becomeFirstResponder()
        }
        
        if textField == self.sobreTiTextField {
            
            self.view.endEditing(true)
        }
        
        return true
    }
    
    // MARK: - Actions y Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func quitarFoto(_ sender: AnyObject) {
        self.foto.image = nil
        self.foto.isUserInteractionEnabled = false
        self.fotoFooterView.isHidden = true
        self.quitarFotoButton.isHidden = true
        self.camaraButton.isHidden = true
        
        self.fotoDifuminada.isHidden = true
        self.fotoFooterLabel.text = "¡Listo!"
        
        imageData = Data()
        DataUserDefaults.saveDataFoto(foto: imageData)
    }
    @IBAction func cambiarFoto(_ sender: AnyObject) {
        mostrarOpcionesFoto()
    }
    
    func tomarFoto(_ sender: UITapGestureRecognizer) {
        
        mostrarOpcionesFoto()
    }
    
    func mostrarOpcionesFoto(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.popoverPresentationController?.sourceView = self.fotoTapView
        
        actionSheet.view.tintColor = Colores.MainCTA
        
        let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler:nil)
        
        
        
        let camara = UIAlertAction(title: "Cámara", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                    
                } else {
                    print("No se tiene acceso a la camara")
                }
            } else {
                print("No se puede acceder a la camara")
            }
            
            
        })
        
        let album = UIAlertAction(title: "Carrete", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                    
                } else {
                    print("No se tiene acceso a la libreria")
                }
            } else {
                print("No se puede acceder a la libreria")
            }
            
            
        })
        
        actionSheet.addAction(camara)
        actionSheet.addAction(album)
        
        actionSheet.addAction(cancelar)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            actualizarFoto(image: image)
            imageData = UIImageJPEGRepresentation(image, 1)!
            DataUserDefaults.saveDataFoto(foto: imageData)
        } else{
            print("Error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    @IBAction func ocultarFotoDifuminadaIn(_ sender: AnyObject) {
        
        self.fotoDifuminada.isHidden = !self.fotoDifuminada.isHidden
        
        if !self.fotoDifuminada.isHidden {
            self.fotoFooterLabel.text = "Así te verían los desconocidos ;)"
        } else {
            self.fotoFooterLabel.text = "¡Listo!"
        }
    }
    
    
    // MARK: API
    
    func validateAndContinue(){
        DataUserDefaults.saveDataProfesion(profesion: self.profesionTextField.text!)
        DataUserDefaults.saveDataSobreMi(sobreti: self.sobreTiTextField.text!)
        if(imageData.count<=0){
            DataUserDefaults.saveDataFoto(foto: Data())
        }
    }
    
    func actualizarFoto(image: UIImage) {
        self.foto.image = image
        self.fotoDifuminada.image = Utilerias.aplicarEfectoDifuminacionImagen(image, intensidad: 100)
        self.foto.isUserInteractionEnabled = true
        self.fotoFooterView.isHidden = false
        self.quitarFotoButton.isHidden = false
        self.camaraButton.isHidden = false
        
        self.fotoDifuminada.isHidden = true
        self.fotoFooterLabel.text = "¡Listo!"
        
    }
    

}
