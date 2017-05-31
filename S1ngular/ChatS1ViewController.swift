//
//  ChatS1ViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class ChatS1ViewController: UIViewController {
    @IBOutlet weak var subtituloView: UIView!
    @IBOutlet weak var subtituloTexto: UILabel!
    @IBOutlet weak var profilePersona: UIBarButtonItem!
    @IBOutlet weak var bloquearBarButton: UIBarButtonItem!
    
    let imageTestUrl = "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg"
    
    var imageTes = UIImageView()
    var bloquearButton = UIButton()
    var tapViewImage = UIGestureRecognizer()

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
        
        //POniendo la imagen de perfil de la otra persona en el navigation bar
        imageTes.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageTes.clipsToBounds = true
        imageTes.contentMode = .scaleAspectFit
        imageTes.layer.cornerRadius = imageTes.frame.size.width / 2;
        imageTes.downloadedFrom(link: imageTestUrl)
        
        tapViewImage = UITapGestureRecognizer(target: self, action: #selector(self.gotoPerfilPersona(sender:)))
        tapViewImage.cancelsTouchesInView = false
        imageTes.addGestureRecognizer(tapViewImage)
        profilePersona.customView = imageTes
        
        //Poniendo el boton de bloquear en el navigation bar
        bloquearButton.frame = CGRect(x:0,y:0,width:75,height:30)
        bloquearButton.backgroundColor = UIColor.white
        bloquearButton.layer.cornerRadius = bloquearButton.bounds.size.height/2
        let NormalTitle = NSAttributedString(string: "BLOQUEAR",                                        attributes: [NSFontAttributeName: UIFont(name: "BrandonGrotesque-Light", size: 13)!,NSForegroundColorAttributeName : Colores.BGPink])
        bloquearButton.setAttributedTitle(NormalTitle, for: .normal)
        bloquearButton.titleLabel?.textAlignment = NSTextAlignment.center
        bloquearButton.addTarget(self, action:#selector(gotoBloquear(sender:)), for: .touchUpInside)
        bloquearBarButton.customView = bloquearButton
        
    }
    
    func gotoBloquear(sender: UIButton){
        self.performSegue(withIdentifier: "gotoBloquear", sender: nil)
    }
    
    func gotoPerfilPersona(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoPerfilPersona", sender: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
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
