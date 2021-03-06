//
//  HacerCheckInViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class HacerCheckInViewController: UIViewController {

    @IBOutlet weak var subtituloView: UIView!
    var showControllsFor : Int = DataUserDefaults.getControllsCheckin()
    @IBOutlet weak var subtituloText: UILabel!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(gobackk), name: NSNotification.Name(rawValue: "goback"), object: nil)
        if showControllsFor == 2{
            changeTitleName(title:"MI CHECK IN")
        }else if showControllsFor == 3{
            changeTitleName(title:"VISTA CHECK IN")
            subtituloText.text = "¡MIRA DÓNDE ANDAN TUS AMIGOS!"
        }else if showControllsFor == 4{
            subtituloText.text = "¡MIRA DóNDE HAY MÁS S1NGULARES!"
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
    
    func changeTitleName(title:String){
        self.title = title
    }
    
    func gobackk(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Actions y Eventos
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
