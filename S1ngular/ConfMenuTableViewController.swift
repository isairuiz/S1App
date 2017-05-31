//
//  ConfMenuTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 03/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit



class ConfMenuTableViewController: UITableViewController {
    

    @IBOutlet weak var editarPerfilButton: UIView!

    @IBOutlet weak var editarPerfilCell: UITableViewCell!
    @IBOutlet weak var prefButton: UIButton!
    @IBOutlet weak var notifButton: UIButton!
    
    @IBOutlet var cerrarSesionButton: UIButton!
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Add a background view to the table view
        
        
        editarPerfilButton.layer.shadowColor = UIColor.black.cgColor
        editarPerfilButton.layer.shadowOpacity = 0.5
        editarPerfilButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        editarPerfilButton.layer.shadowRadius = 3
        
        transformButton(button: self.prefButton)
        transformButton(button: self.notifButton)
        transformButton(button: self.cerrarSesionButton)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.editarPerfilButtonTap(_:)))
        self.editarPerfilCell.addGestureRecognizer(tapView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    
    func editarPerfilButtonTap(_ sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)

    }
    
    func transformButton(button:UIButton){
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = ColoresTexto.TXTMain.cgColor
        button.backgroundColor = UIColor.clear
        
        
        button.setTitleColor(ColoresTexto.TXTMain, for: UIControlState.normal)
        button.setTitleColor(ColoresTexto.TXTMainAlpha, for: UIControlState.highlighted)
        
        button.titleLabel?.font = UIFont(name: "BrandonGrotesque-Medium", size: 19)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: button.bounds.size.height / 2, bottom: 0, right: button.bounds.size.height / 2)
    }
    
    func showActivityIndicator() {
        
        cerrarSesionButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator(){
        cerrarSesionButton.isHidden = false
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }


    @IBAction func gotoEditarPreferencias(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifEditarPreferencias"), object: nil)
    }

    @IBAction func gotoNotificaciones(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifNotificaciones"), object: nil)
    }
    @IBAction func cerrarSesion(_ sender: Any) {
        showActivityIndicator()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifCerrarSesion"), object: nil)
    }
}
