//
//  EditarMiPerfil3ViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 09/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class EditarMiPerfil3ViewController:UIViewController{
    
    @IBOutlet weak var subtituloView: UIView!
    
    var childController: EditarMiperfil3TableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        // Borramos la line inferior del Navigationbar para que se una al subtitulo
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.subtituloView.layer.shadowColor = UIColor.black.cgColor
        self.subtituloView.layer.shadowOpacity = 0.5
        self.subtituloView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.subtituloView.layer.shadowRadius = 3
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeNow), name: NSNotification.Name(rawValue: "notifFinishEditing"), object: nil)
        
    }
    
    func closeNow(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditarMiperfil3TableViewController, segue.identifier == "editarPerfilSegue3"{
            self.childController = vc
        }
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
    // MARK: - Actions y Eventos
    
    @IBAction func regresar(_ sender: AnyObject) {
        let doit = self.childController.setTempChangesIfNeeded()
        if doit{
            let isChange = self.childController.lookForLocalChanges()
            if isChange{
                let alert = UIAlertController(title: "¿Desea continuar?", message: "Se han encontrado cambios, presione continuar para guardarlos.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: { action in
                        self.childController.uploadChanges()
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {action in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}

