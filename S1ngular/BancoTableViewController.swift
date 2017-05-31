//
//  BancoTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 12/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController


class BancoTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var item1S1Credits: UITableViewCell!
    @IBOutlet weak var item2S1Credits: UITableViewCell!
    @IBOutlet weak var item3S1Credits: UITableViewCell!
    @IBOutlet weak var cuponTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.item1S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item1S1Credits.layer.shadowOpacity = 0.5
        self.item1S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item1S1Credits.layer.shadowRadius = 3
        
        
        self.item2S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item2S1Credits.layer.shadowOpacity = 0.5
        self.item2S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item2S1Credits.layer.shadowRadius = 3
        
        
        self.item3S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item3S1Credits.layer.shadowOpacity = 0.5
        self.item3S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item3S1Credits.layer.shadowRadius = 3
        
        self.cuponTextField.delegate = self
        
        let tapViewItem1 = UITapGestureRecognizer(target: self, action: #selector(self.showCustomAlert(sender:)))
        let tapViewItem2 = UITapGestureRecognizer(target: self, action: #selector(self.showCustomAlert(sender:)))
        let tapViewItem3 = UITapGestureRecognizer(target: self, action: #selector(self.showCustomAlert(sender:)))
        
        self.item1S1Credits.addGestureRecognizer(tapViewItem1)
        self.item2S1Credits.addGestureRecognizer(tapViewItem2)
        self.item3S1Credits.addGestureRecognizer(tapViewItem3)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        

    }
    
    func showCustomAlert(sender: UITapGestureRecognizer){
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CustomAlert")
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: viewController)
        formSheetController.presentationController?.isTransparentTouchEnabled = false
        self.present(formSheetController, animated: true, completion: nil)
        
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
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 8.0;
        }
        
        return tableView.sectionHeaderHeight;
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == self.cuponTextField {
            
            self.view.endEditing(true)
            // Enviar
        }
        
        return true
    }
    
    // MARK: - Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // MARK: -Actions
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
