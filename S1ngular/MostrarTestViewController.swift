//
//  MostrarTestViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 01/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class MostrarTestViewController: UIViewController {
    
    @IBOutlet weak var subtituloView: UIView!
    var item: TestItem?
    var childViewController = DetalleTestTableViewController()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoResultado), name: NSNotification.Name(rawValue: "gotoResultado"), object: nil)
    }
    
    func gotoResultado(notification:NSNotification){
        self.performSegue(withIdentifier: "gotoResultado", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetalleTestTableViewController, segue.identifier == "testChildSegue"{
            self.childViewController = vc
        }
    }
    override func viewWillAppear(_ animated: Bool) {
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
        
        self.view.insertSubview(view, at: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions y Eventos
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
