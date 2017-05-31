//
//  BloquearS1TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 30/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class BloquearS1TableViewController: UITableViewController {

    @IBOutlet weak var razon1Cell: UITableViewCell!
    @IBOutlet weak var razon2Cell: UITableViewCell!
    @IBOutlet weak var razon3Cell: UITableViewCell!
    @IBOutlet weak var razon4Cell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.razon1Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon1Cell.layer.shadowOpacity = 0.5
        self.razon1Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon1Cell.layer.shadowRadius = 3
        
        self.razon2Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon2Cell.layer.shadowOpacity = 0.5
        self.razon2Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon2Cell.layer.shadowRadius = 3
        
        self.razon3Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon3Cell.layer.shadowOpacity = 0.5
        self.razon3Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon3Cell.layer.shadowRadius = 3
        
        self.razon4Cell.layer.shadowColor = UIColor.black.cgColor
        self.razon4Cell.layer.shadowOpacity = 0.5
        self.razon4Cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.razon4Cell.layer.shadowRadius = 3
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
}
