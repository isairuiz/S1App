//
//  EditarMiPerfilViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 04/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class EditarMiPerfilViewController: UIViewController {

    @IBOutlet weak var subtituloView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.subtituloView.layer.shadowColor = UIColor.black.cgColor
        self.subtituloView.layer.shadowOpacity = 0.5
        self.subtituloView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.subtituloView.layer.shadowRadius = 3
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoEditarUsuario), name: NSNotification.Name(rawValue: "notifEditUsuario"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoMisFotos), name: NSNotification.Name(rawValue: "notifMisFotos"), object: nil)
    }
    
    func gotoMisFotos(){
        self.performSegue(withIdentifier: "gotoMisFotos", sender: nil)
    }
    
    func gotoEditarUsuario(){
        self.performSegue(withIdentifier: "gotoEditarUsuario", sender: nil)
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
        
        self.view.insertSubview(view, at:0)
        
    }
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
