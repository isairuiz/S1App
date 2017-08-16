//
//  YeahTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 21/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class YeahTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var s1Splash: UIImageView!
    @IBOutlet weak var microfonoButton: UIImageView!
    @IBOutlet weak var escribeDespuesButton: UIButton!

    @IBOutlet weak var fotosEnMedioCell: UITableViewCell!
    
    var fotosPersonas = [String]()
    let reuseIdentifier = "fotoCell"
    
    
    var tapMicro = UIGestureRecognizer()
    var tapDespues = UIGestureRecognizer()
    
    let jsonPerfilString = DataUserDefaults.getJsonPerfilPersona()
    var jsonPerfilObject : JSON?
    var foto_blur:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        self.fotosPersonas.append(DataUserDefaults.getFotoPerfilUrl())
        
        self.s1Splash.layer.cornerRadius = self.s1Splash.frame.size.width/2
        self.s1Splash.layer.backgroundColor = Colores.MainK.cgColor
        
        
        self.microfonoButton.layer.shadowColor = ColoresTexto.InfoKAlpha.cgColor
        self.microfonoButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.microfonoButton.layer.shadowOpacity = 1.0
        self.microfonoButton.layer.shadowRadius = 3
        self.microfonoButton.layer.masksToBounds = false
        
        self.escribeDespuesButton.layer.cornerRadius = self.escribeDespuesButton.bounds.size.height / 2
        
        tapMicro = UITapGestureRecognizer(target: self, action: #selector(self.gotoChat(sender:)))
        tapDespues = UITapGestureRecognizer(target: self, action: #selector(self.despues(sender:)))
        
        self.microfonoButton.addGestureRecognizer(tapMicro)
        self.escribeDespuesButton.addGestureRecognizer(tapDespues)
        if let dataFromString = jsonPerfilString.data(using: .utf8, allowLossyConversion: false){
            jsonPerfilObject = JSON(data: dataFromString)
            
            
            let foto_visible = jsonPerfilObject?["foto_visible"].floatValue
            self.foto_blur = foto_visible!
            
            if let Urlimage = jsonPerfilObject?["imagen"].string{
                var fotoUrl:String = Constantes.BASE_URL
                fotoUrl += Urlimage
                self.fotosPersonas.append(fotoUrl)
            }
            
        }
    }
    
    func gotoChat(sender: UITapGestureRecognizer){
        DataUserDefaults.setPushType(type: "0")
        self.performSegue(withIdentifier: "gotoChat", sender: nil)
    }
    func despues(sender: UITapGestureRecognizer){
        DataUserDefaults.setPushType(type: "0")
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "MainBG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.view.insertSubview(imageView, at: 0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fotosPersonas.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! YeahCollectionViewCell
        
        if indexPath.row == 1{
            cell.imagenPersona.downloadedFrom(link: fotosPersonas[indexPath.row],withBlur:true,maxBlur:self.foto_blur)
        }else{
            cell.imagenPersona.downloadedFrom(link: fotosPersonas[indexPath.row],withBlur:false,maxBlur:0)
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 00
        layout.minimumLineSpacing = 00
        layout.invalidateLayout()
        
        return CGSize(
            width: ((self.fotosEnMedioCell.frame.width/2) - 2),
            height:self.fotosEnMedioCell.frame.height )
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    // MARK: - Table view data source


    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}


