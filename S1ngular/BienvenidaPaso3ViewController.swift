//
//  BienvenidaPaso3ViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class BienvenidaPaso3ViewController: UIViewController {

    @IBOutlet weak var subtituloView: UIView!
    var childController: BienvenidaPaso3TableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BienvenidaPaso3TableViewController, segue.identifier == "bienvenidaSegue3"{
            self.childController = vc
        }
    }
    
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
    
    
    func processData(){
        self.childController.validateAndContinue()
    }
    
    
    func sendRequestEditarQueBusco(){
        
    }
    func sendRequestAgregarFoto(){
        
    }
    @IBAction func gotoMinitour(_ sender: Any) {
        processData()
        self.performSegue(withIdentifier: "gotoMinitour", sender: nil)
    }


}
