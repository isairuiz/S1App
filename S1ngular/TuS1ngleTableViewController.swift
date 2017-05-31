//
//  TuS1ngleTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class TuS1ngleTableViewController: UITableViewController {
    
    @IBOutlet weak var FloatingView: UIVisualEffectView!
    @IBOutlet weak var Floating2: UIView!
    @IBOutlet weak var statsButton: UIImageView!
    @IBOutlet weak var imagePerifl: UIImageView!
    
    @IBOutlet weak var afinidadTotal: UILabel!
    @IBOutlet weak var afinidad1: UILabel!
    @IBOutlet weak var afinidad2: UILabel!
    @IBOutlet weak var afinidad3: UILabel!
    
    var tapViewLentes = UITapGestureRecognizer()
    var tapViewFloating = UITapGestureRecognizer()
    var tapViewStats = UITapGestureRecognizer()
    var tapViewImagen = UIGestureRecognizer()
    var isShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        tapViewFloating = UITapGestureRecognizer(target: self, action: #selector(self.animateFloatingUpDown(sender:)))
        tapViewFloating.cancelsTouchesInView = false
        Floating2.addGestureRecognizer(tapViewFloating)
        
        tapViewStats = UITapGestureRecognizer(target: self, action: #selector(self.showStatsUp(sender:)))
        tapViewStats.cancelsTouchesInView = false
        statsButton.addGestureRecognizer(tapViewStats)
        
        tapViewImagen = UITapGestureRecognizer(target: self, action: #selector(self.gotoFotosPersona(sender:)))
        tapViewImagen.cancelsTouchesInView = false
        imagePerifl.addGestureRecognizer(tapViewImagen)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoFotosPersona(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoFotosPersona", sender: nil)
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
    
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source



}
