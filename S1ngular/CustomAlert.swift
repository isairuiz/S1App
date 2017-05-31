//
//  CustomAlert.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 27/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

protocol ButtonActionsDelegate{
    func confirmButtonPressed(button:UIButton)
}

class CustomAlert: UIViewController {

    var delegate:ButtonActionsDelegate!
    @IBOutlet weak var iconAlert: UIImageView!
    let layer = CAShapeLayer()
    let path = CGMutablePath()
    @IBOutlet weak var infoTextAlert: UILabel!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = Colores.BGWhiteTransparent
        
        self.iconAlert.layer.cornerRadius = self.iconAlert.frame.size.width/2
        self.iconAlert.layer.borderColor = Colores.BGWhite.cgColor as CGColor
        self.iconAlert.layer.borderWidth = 2
        self.iconAlert.clipsToBounds = true
        
        self.infoTextAlert.font = UIFont(name: "BrandonGrotesque-Light", size: 22)
        self.infoTextAlert.textColor = Colores.MainCTA
        
        self.buttonConfirm.layer.cornerRadius = 0.5 * self.buttonConfirm.bounds.size.width
        self.buttonConfirm.layer.borderColor = Colores.MainCTA.cgColor as CGColor
        self.buttonConfirm.layer.borderWidth = 1.0
        self.buttonConfirm.clipsToBounds = true
        self.buttonConfirm.backgroundColor = Colores.MainCTA
        self.buttonConfirm.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.buttonConfirm.layer.shadowColor = ColoresTexto.InfoKAlpha.cgColor
        self.buttonConfirm.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.buttonConfirm.layer.shadowOpacity = 1.0
        self.buttonConfirm.layer.shadowRadius = 3
        self.buttonConfirm.layer.masksToBounds = false
        
        
        self.buttonCancel.layer.cornerRadius = 0.5 * self.buttonCancel.bounds.size.width
        self.buttonCancel.layer.borderColor = Colores.TabBar.cgColor as CGColor
        self.buttonCancel.layer.borderWidth = 1.0
        self.buttonCancel.clipsToBounds = true
        self.buttonCancel.backgroundColor = Colores.TabBar
        self.buttonCancel.titleLabel?.font = UIFont(name: "BrandonGrotesque-Black", size: 16)
        self.buttonCancel.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.buttonCancel.layer.shadowOpacity = 1.0
        self.buttonCancel.layer.shadowRadius = 3
        self.buttonCancel.layer.masksToBounds = false
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        
    }

    
    func close() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CloseAlert(_ sender: Any) {
        close()
    }
    
    @IBAction func ConfirmAlert(_ sender: UIButton) {
        delegate.confirmButtonPressed(button: sender)
    }
    /*
    // MARK: - Navigat
     ion

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

