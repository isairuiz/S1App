//
//  ResultadoTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 04/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class ResultadoTableViewController: UITableViewController {
    
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    
    @IBOutlet weak var compartirCheckInViewButton: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        let compartirCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirCheckInTap)

        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
    }
    
    func compartirCheckIn(){
        
        print("compartir")
        
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

    // MARK: - Table view data source

}
