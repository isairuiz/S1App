//
//  AgregarFotoTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AgregarFotoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var fotoTapView: UIVisualEffectView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var fotoDifuminada: UIImageView!
    
    @IBOutlet weak var quitarFotoButton: UIButton!
    @IBOutlet weak var camaraButton: UIButton!
    
    @IBOutlet weak var fotoFooterView: UIVisualEffectView!
    @IBOutlet weak var fotoFooterLabel: UILabel!
    
    @IBOutlet weak var subirFotoCell: UITableViewCell!
    @IBOutlet weak var subirFotoButton: UIView!
    
    var headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var imageData = Data()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.subirFotoTap(_:)))
        self.subirFotoCell.addGestureRecognizer(tapView)
        
    }
    
    func subirFotoTap(_ sender: UITapGestureRecognizer){
        let photo = imageData
        let noFoto = photo.count<=0
        if(!noFoto){
            let view = UIView()
            let labell = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreenForView(loadingView: view, view: self.view, loadingLabel: labell, spinner: spinner)
            var imageName = "image"+Utilerias.getCurrentDateAndTime()+".jpeg"
            
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
                                    Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: labell, spinner: spinner)
                                    self.showAlerWithMessage(title:"¡Bien!",message: "Has agregado una foto.")
                                    
                                    self.foto.image = nil
                                    self.foto.isUserInteractionEnabled = false
                                    self.fotoFooterView.isHidden = true
                                    self.quitarFotoButton.isHidden = true
                                    self.camaraButton.isHidden = true
                                    
                                    self.fotoDifuminada.isHidden = true
                                    self.fotoFooterLabel.text = "¡Listo!"
                                    
                                    self.imageData = Data()
                                    
                                }else{
                                    if let message = json["mensaje_plain"].string{
                                        Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: labell, spinner: spinner)
                                        self.showAlerWithMessage(title:"Error",message: message)
                                    }
                                    Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: labell, spinner: spinner)
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        Utilerias.removeCustomLoadingScreen(loadingView: view, loadingLabel: labell, spinner: spinner)
                    }
            }
            )
        }else{
            
        }
    }
    
    func showAlerWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

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
        return 78
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
