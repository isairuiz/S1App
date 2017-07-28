//
//  ConfMenuViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 03/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class ConfMenuViewController: UIViewController {

    @IBOutlet weak var subtituloView: UIView!
    
    var childController: ConfMenuTableViewController!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoEditarPefil), name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoEditarPreferencias), name: NSNotification.Name(rawValue: "notifEditarPreferencias"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoNotificaciones), name: NSNotification.Name(rawValue: "notifNotificaciones"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoCerrarSesion), name: NSNotification.Name(rawValue: "notifCerrarSesion"), object: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfMenuTableViewController, segue.identifier == "configChildEmbed"{
            self.childController = vc
        }
    }

    func gotoEditarPefil(){
        self.performSegue(withIdentifier: "gotoEditarPerfil", sender: nil)
    }
    func gotoEditarPreferencias(){
        self.performSegue(withIdentifier: "gotoPreferencias", sender: nil)
    }
    func gotoNotificaciones(){
        self.performSegue(withIdentifier: "gotoNotificaciones", sender: nil)
    }
    func gotoCerrarSesion(){
        if(DataUserDefaults.clearData()){
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
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
    // MARK: - Navigation


}
