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
    @IBOutlet weak var editarPrefButton: UIView!
    @IBOutlet weak var editarNotifButton: UIView!
    @IBOutlet weak var cerrarButton: UIView!

    @IBOutlet weak var editarPerfilCell: UITableViewCell!
    @IBOutlet weak var prefButton: UITableViewCell!
    @IBOutlet weak var notifButton: UITableViewCell!
    @IBOutlet var cerrarSesionButton: UITableViewCell!
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Add a background view to the table view
        
        
        self.styleButton(button: editarPerfilButton)
        self.styleButton(button: editarPrefButton)
        self.styleButton(button: editarNotifButton)
        self.styleButton(button: cerrarButton)
        
        
        let tapView1 = UITapGestureRecognizer(target: self, action: #selector(self.editarPerfilButtonTap(_:)))
        let tapView2 = UITapGestureRecognizer(target: self, action: #selector(self.gotoEditarPreferencias(_:)))
        let tapView3 = UITapGestureRecognizer(target: self, action: #selector(self.gotoNotificaciones(_:)))
        let tapView4 = UITapGestureRecognizer(target: self, action: #selector(self.cerrarSesion(_:)))
        
        self.editarPerfilCell.addGestureRecognizer(tapView1)
        self.prefButton.addGestureRecognizer(tapView2)
        self.notifButton.addGestureRecognizer(tapView3)
        self.cerrarSesionButton.addGestureRecognizer(tapView4)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    
    func editarPerfilButtonTap(_ sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)
    }
    
    func gotoEditarPreferencias(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifEditarPreferencias"), object: nil)
    }
    
    func gotoNotificaciones(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifNotificaciones"), object: nil)
    }
    func cerrarSesion(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifCerrarSesion"), object: nil)
    }
    /*func transformButton(button:UIButton){
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
    }*/
    
    func styleButton(button:UIView){
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
