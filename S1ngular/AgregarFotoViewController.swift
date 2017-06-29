//
//  AgregarFotoViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class AgregarFotoViewController: UIViewController {
    
    @IBOutlet weak var subtituloView: UIView!

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

        // Do any additional setup after loading the view.
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
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }


}
