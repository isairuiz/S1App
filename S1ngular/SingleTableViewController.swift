//
//  SingleTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 16/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class SingleTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var FloatingView: UIVisualEffectView!
    @IBOutlet weak var Floating2: UIView!
    @IBOutlet weak var statsButton: UIImageView!
    @IBOutlet weak var imagePerifl: UIImageView!
    
    
    @IBOutlet weak var lentesButton: UIImageView!
    @IBOutlet weak var afinidadPreview: UILabel!
    @IBOutlet weak var afinidadTotal: UILabel!
    @IBOutlet weak var afinidad1: UILabel!
    @IBOutlet weak var afinidad2: UILabel!
    @IBOutlet weak var afinidad3: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var siButton: UIButton!
    
    var idVerPerfil = Int()
    var isShowing = false
    var swipeDown = UISwipeGestureRecognizer()
    var swipeUp = UISwipeGestureRecognizer()
    var scrollView = UIScrollView()
    var tapViewLentes = UITapGestureRecognizer()
    var tapViewFloating = UITapGestureRecognizer()
    var tapViewStats = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeDown))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeUp))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up*/

        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.delegate = self
        //swipeDown.delegate = self
        //swipeUp.delegate = self
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        idVerPerfil = DataUserDefaults.getIdVerPerfil()
        
        tapViewLentes = UITapGestureRecognizer(target: self, action: #selector(self.desBlurFoto(sender:)))
        tapViewLentes.cancelsTouchesInView = false
        lentesButton.addGestureRecognizer(tapViewLentes)
        
        tapViewFloating = UITapGestureRecognizer(target: self, action: #selector(self.animateFloatingUpDown(sender:)))
        tapViewFloating.cancelsTouchesInView = false
        Floating2.addGestureRecognizer(tapViewFloating)
        
        tapViewStats = UITapGestureRecognizer(target: self, action: #selector(self.showStatsUp(sender:)))
        tapViewStats.cancelsTouchesInView = false
        statsButton.addGestureRecognizer(tapViewStats)
        
        
        makeLabelRounded(label: self.afinidadPreview)
        makeLabelRounded(label: self.afinidadTotal)
        makeLabelRounded(label: self.afinidad1)
        makeLabelRounded(label: self.afinidad2)
        makeLabelRounded(label: self.afinidad3)
        
        
        
        //self.Floating2.addGestureRecognizer(swipeDown)
        //self.Floating2.addGestureRecognizer(swipeUp)
        
        
        
        self.siButton.layer.cornerRadius = 0.5 * self.siButton.bounds.size.width
        self.siButton.layer.borderColor = Colores.MainCTA.cgColor as CGColor
        self.siButton.layer.borderWidth = 1.0
        self.siButton.clipsToBounds = true
        self.siButton.backgroundColor = Colores.MainCTA
        self.siButton.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.siButton.layer.shadowColor = ColoresTexto.InfoKAlpha.cgColor
        self.siButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.siButton.layer.shadowOpacity = 1.0
        self.siButton.layer.shadowRadius = 3
        self.siButton.layer.masksToBounds = false
        
        self.noButton.layer.cornerRadius = 0.5 * self.noButton.bounds.size.width
        self.noButton.layer.borderColor = Colores.TabBar.cgColor as CGColor
        self.noButton.layer.borderWidth = 1.0
        self.noButton.clipsToBounds = true
        self.noButton.backgroundColor = Colores.TabBar
        self.noButton.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.noButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.noButton.layer.shadowOpacity = 1.0
        self.noButton.layer.shadowRadius = 3
        self.noButton.layer.masksToBounds = false
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
        
        self.tableView.backgroundView = view
    }
    
    func desBlurFoto(sender: UITapGestureRecognizer){
        debugPrint("desblurreame esta")
        self.scrollView.isScrollEnabled = true
    }
    
    
    func animateFloatingUpDown(sender: UITapGestureRecognizer){
        if(isShowing){
            self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.FloatingView.center.y += (self.FloatingView.superview?.bounds.height)! - 85
                            self.Floating2.center.y += (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = false
            })
        }else{
            self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.FloatingView.center.y -= (self.FloatingView.superview?.bounds.height)! - 85
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }
    
    func showStatsUp(sender: UITapGestureRecognizer){
        if(self.isShowing==false){
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.FloatingView.center.y -= (self.FloatingView.superview?.bounds.height)! - 85
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
            return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func respondToSwipeDown(gesture: UISwipeGestureRecognizer){
        if(isShowing){
            self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.FloatingView.center.y += (self.FloatingView.superview?.bounds.height)! - 85
                            self.Floating2.center.y += (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = false
            })
        }
        
    }
    func respondToSwipeUp(gesture: UISwipeGestureRecognizer){
        if(isShowing==false){
            self.tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.FloatingView.center.y -= (self.FloatingView.superview?.bounds.height)! - 85
                            self.Floating2.center.y -= (self.Floating2.superview?.bounds.height)! - 85
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.isShowing = true
            })
        }
        
    }

    // MARK: - Table view data source



    
    @IBAction func aceptarSingular(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoYeah", sender: nil)
    }
    
    @IBAction func rechazarSingular(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func makeLabelRounded(label:UILabel){
        label.layer.cornerRadius = 0.5 * label.bounds.size.width
    }

    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
