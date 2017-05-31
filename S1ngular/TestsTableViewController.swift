//
//  TestsTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 17/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class TestsTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaResultados:[TestItem] = []
    var listaNuevos:[TestItem] = []
    
    var saldo = UILabel(frame:(CGRect(x: 40, y: 0, width: 58, height: 37)))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        
        
        let img = UIImage(named: "TagSaldo")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.addTarget(self, action: #selector(self.verSaldo), for: UIControlEvents.touchUpInside)
        rightButton.setImage(img, for: UIControlState.normal)
      
        rightButton.frame = CGRect(x: 0, y: 0, width: 103, height: 37)
        
        
        
        saldo.text = "100"
        saldo.textColor = UIColor.white
        saldo.font = UIFont(name: "BrandonGrotesque-Bold", size: 15)!
        saldo.textAlignment = .center
        
        rightButton.addSubview(saldo)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("NUEVOS", derecha: "RESULTADOS")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        listaNuevos = [
            TestItem(id: 1, nombre: "HABLEMOS DE SEXO", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 50, recompensa: 1000, imagen: "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg"),
            TestItem(id: 1, nombre: "ZODIACO S1NGULAR", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 10, recompensa: 50, imagen: "https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1"),
            TestItem(id: 1, nombre: "TIPOS DE SOLTERO", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 20, recompensa: 100, imagen: "http://i.dailymail.co.uk/i/pix/2015/05/29/02/2929496B00000578-3101635-image-a-1_1432862935225.jpg")
        ]
        
        listaResultados = [
            TestItem(id: 1, nombre: "PREFERENCIAS EN LA CAMA", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 50, recompensa: 1000, imagen: "http://mommyatozblog.com/wp-content/uploads/2014/10/couple-in-bed.jpg?w=300", resultado:"¡Eres una tigresa a full!"),
            TestItem(id: 1, nombre: "JUEGOS SEXUALES", descripcion: "Descripción del Test: \"Con quién eres mejor en el sexo. Una guía para disfrutar en la cama.\" Límite 120 char.", costo: 10, recompensa: 50, imagen: "http://www.appsgalery.com/pictures/000/140/-exy--ames-140523.png",resultado:"¡Eres una tigresa a full!")
        ]
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

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if self.tab.tabSeleccionada == 0 {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tab.tabSeleccionada == 0 {
            return 140
        }
        return 108
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tab
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.tab.tabSeleccionada == 0 {
            return self.listaNuevos.count
        }
        
        return self.listaResultados.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.tab.tabSeleccionada == 0 ? tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) : tableView.dequeueReusableCell(withIdentifier: "CeldaResultados", for: indexPath)
        
        // Configure the cell...
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        var imagenURL:String = ""
        
        var item: TestItem?
        
        if self.tab.tabSeleccionada == 0 {
            
            item = self.listaNuevos[(indexPath as NSIndexPath).row]
            
          
            
            
            let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
            (cell.viewWithTag(2) as? UILabel)?.attributedText = descripcion
            (cell.viewWithTag(2) as? UILabel)?.lineBreakMode = .byTruncatingTail
            
            (cell.viewWithTag(3) as? UILabel)?.text = "+ \(item!.recompensa) S1NGLE CREDITS"
            (cell.viewWithTag(4) as? UILabel)?.text = "-\(item!.costo)"
            
        } else{
            item = self.listaResultados[(indexPath as NSIndexPath).row]
            
            let descripcion = NSMutableAttributedString(string: "Resultado:\n\(item!.resultado)", attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
            (cell.viewWithTag(2) as? UILabel)?.attributedText = descripcion
            (cell.viewWithTag(2) as? UILabel)?.lineBreakMode = .byTruncatingTail
            
            (cell.viewWithTag(3) as? UILabel)?.text = "+ \(item!.recompensa) S1NGLE CREDITS"
            
            (cell.viewWithTag(6) as? UIButton)?.layoutIfNeeded()
            (cell.viewWithTag(6) as? UIButton)?.layer.cornerRadius = ((cell.viewWithTag(6) as? UIButton)?.bounds.height)! / 2
            
        }
        
        (cell.viewWithTag(1) as? UILabel)?.text = item!.nombre
        
        imagenURL = item!.imagen
        
        let imagen =  self.imagenCache[imagenURL];
        (cell.viewWithTag(5) as? UIImageView)?.image = nil
        
        if(imagen == nil){
            // Si la imagen no exite hay que descargarla
            if imagenURL != "" {
                let url:URL = URL(string: "\(imagenURL)" )!
                let session = URLSession.shared;
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = url;
                request.httpMethod = "GET"
                
                
                let task = session.dataTask(with: request as URLRequest){data,response, error in
                   
            
                    guard data != nil else {
                        (cell.viewWithTag(5) as? UIImageView)?.image = nil
                        return
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let imagen = UIImage(data: data!) {
                            self.imagenCache[imagenURL] = imagen;
                            if let cell = tableView.cellForRow(at: indexPath) {
                                
                                (cell.viewWithTag(5) as? UIImageView)?.image = imagen
                                
                            }
                        } else {
                            if let cell = tableView.cellForRow(at: indexPath) {
                                (cell.viewWithTag(5) as? UIImageView)?.image = nil
                            }
                        }
                    })
                };
                task.resume()
            } else {
                (cell.viewWithTag(5) as? UIImageView)?.image = nil
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = tableView.cellForRow(at: indexPath) {
                    (cell.viewWithTag(5) as? UIImageView)?.image = imagen
                }
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tab.tabSeleccionada == 0 {
            self.performSegue(withIdentifier: "MostrarTest", sender: self)
        }
    }
    
    // MARK: - Acciones y eventos
    
    func cambiarPrimerTab (){
        self.tableView.reloadData()
    }
    
    func cambiarSegundoTab (){
        self.tableView.reloadData()
    }
    
    func verSaldo(){
        saldo.text = "100000"
    }

}
