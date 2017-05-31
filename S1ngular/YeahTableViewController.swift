//
//  YeahTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 21/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class YeahTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var s1Splash: UIImageView!
    @IBOutlet weak var microfonoButton: UIImageView!
    @IBOutlet weak var escribeDespuesButton: UIButton!

    @IBOutlet weak var fotosEnMedioCell: UITableViewCell!
    
    var fotosPersonas = [String]()
    let reuseIdentifier = "fotoCell"
    
    
    var tapMicro = UIGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        
        
        self.fotosPersonas.append("http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg")
        self.fotosPersonas.append("https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1")
        
        self.s1Splash.layer.cornerRadius = self.s1Splash.frame.size.width/2
        self.s1Splash.layer.backgroundColor = Colores.MainK.cgColor
        
        //self.microfonoButton.layer.cornerRadius = self.microfonoButton.frame.size.width/2
        
        self.microfonoButton.layer.shadowColor = ColoresTexto.InfoKAlpha.cgColor
        self.microfonoButton.layer.shadowOffset = CGSize(width:0.0, height:2.0)
        self.microfonoButton.layer.shadowOpacity = 1.0
        self.microfonoButton.layer.shadowRadius = 3
        self.microfonoButton.layer.masksToBounds = false
        
        self.escribeDespuesButton.layer.cornerRadius = self.escribeDespuesButton.bounds.size.height / 2
        
        tapMicro = UITapGestureRecognizer(target: self, action: #selector(self.gotoChat(sender:)))
        tapMicro.cancelsTouchesInView = false
        self.microfonoButton.addGestureRecognizer(tapMicro)
        
        
        //self.imagenPersona.downloadedFrom(link: img1)
        //self.imagenPerfil.downloadedFrom(link: img1)
        
    }
    
    func gotoChat(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoChat", sender: nil)
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
        
        cell.imagenPersona.downloadedFrom(link: fotosPersonas[indexPath.row])
        
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


