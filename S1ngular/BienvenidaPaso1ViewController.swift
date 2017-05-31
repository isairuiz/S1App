//
//  BienvenidaPaso1ViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 21/10/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class BienvenidaPaso1ViewController: UIViewController{
    
    @IBOutlet weak var subtituloView: UIView!
    var childController: BienvenidaPaso1TableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BienvenidaPaso1TableViewController, segue.identifier == "bienvenidaSegue1"{
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
        
        self.view.snapshotView(afterScreenUpdates: true)
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "MainBG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.view.insertSubview(imageView, at: 0)
        
        
    }
   
    @IBAction func gotoPaso2(_ sender: Any) {
        self.childController.validateAndContinue()
        performSegue(withIdentifier: "gotoPaso2", sender: nil)
    }

}
