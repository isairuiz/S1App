//
//  CheckInsTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 13/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class CheckInsTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaCercanos:[GeneralTableItem] = []
    var listaMisCheckIns:[GeneralTableItem] = []
    
    var fondoConfigurado: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("CERCANOS", derecha: "MIS CHECK IN")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        
        self.listaCercanos = [
            GeneralTableItem(id: 1, nombre: "Denisse Aristegui", distancia: "15 metros", tiempo: "", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://www.meganfox.com/wp-content/uploads/2014/01/5.jpg", badge: "42", compartir: false, resaltar: false, restriccion: 50),
            
            GeneralTableItem(id: 1, nombre: "Ryan Duncan", distancia: "37 metros", tiempo: "", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://ell.h-cdn.co/assets/16/07/980x490/landscape-1455813161-elle-henrycavill.jpg", badge: "85", compartir: false, resaltar: false, restriccion: 50),
            
            GeneralTableItem(id: 1, nombre: "Cheryl Arvizu", distancia: "220 metros", tiempo: "", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://caraotadigital.net/site/wp-content/uploads/2016/04/jolie.jpeg", badge: "69", compartir: false, resaltar: false, restriccion: 50),
            
            GeneralTableItem(id: 1, nombre: "Emma Retiz", distancia: "593 metros", tiempo: "", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "https://i.guim.co.uk/img/static/sys-images/Guardian/Pix/pictures/2015/6/30/1435683314339/Emma-Watson-at-the-HeForS-009.jpg?w=620&q=55&auto=format&usm=12&fit=max&s=4bf38511bf665f44afe480d87fb0d9c9", badge: "91", compartir: false, resaltar: false, restriccion: 50),
            
            
            GeneralTableItem(id: 1, nombre: "Joaquín de Mola", distancia: "103 metros", tiempo: "", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://cdn.newsapi.com.au/image/v1/8c092d874974a3e4b9fa060a3b30eb05", badge: "85", compartir: false, resaltar: false, restriccion: 50)
        ]
        
        
        self.listaMisCheckIns = [
            
            
            GeneralTableItem(id: 1, nombre: "YO", distancia: "37 metros", tiempo: "2:30 hrs", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://trendom.co/wp-content/uploads/2015/11/tumblr_nusfkwzzHv1qflffco1_1280.jpg", badge: "42", compartir: true, resaltar: false, restriccion: 0),
            
            GeneralTableItem(id: 1, nombre: "Zac Efron", distancia: "626 metros", tiempo: "7:16 hrs", lugar: "De Barbas", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://pixel.nymag.com/imgs/daily/vulture/2016/01/19/19-zac-efron-tweet-mlk.w529.h529.jpg", badge: "85", compartir: false, resaltar: false, restriccion: 0),
            
            GeneralTableItem(id: 1, nombre: "Megan Licona", distancia: "220 metros", tiempo: "8:58 hrs", lugar: "Zambuca", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://www.stereomar94fm.com.ve/wp-content/uploads/2016/05/ladygaga-500x375.jpg", badge: "69", compartir: false, resaltar: false, restriccion: 10),
            
            GeneralTableItem(id: 1, nombre: "YO", distancia: "3 km", tiempo: "1 día", lugar: "Starbucks Delta", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://trendom.co/wp-content/uploads/2015/11/tumblr_nusfkwzzHv1qflffco1_1280.jpg", badge: "42", compartir: true, resaltar: false, restriccion: 0),
            
            GeneralTableItem(id: 1, nombre: "Pharrell Williams", distancia: "103 metros", tiempo: "2 semanas", lugar: "Chuti de terán", descripcion: "Está increible, me la paso diario después de  las 7PM búscame para estar en contacto.", avatar: "http://media.dlccdn.com/artistas/p/pharrell-williams/pharrell-williams_o.jpg", badge: "85", compartir: false, resaltar: false, restriccion: 20)
            
            
            
        ]
        
        

    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(!fondoConfigurado){
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
            
            fondoConfigurado = true;
        }
        
        
        
    }
    
    
    // MARK: - Funciones y Eventos
    
    func cambiarPrimerTab (){
        self.tableView.reloadData()
    }
    
    func cambiarSegundoTab (){
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 66.0
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.tab
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        
        if self.tab.tabSeleccionada == 0 {
            return self.listaCercanos.count
        }
        
        return self.listaMisCheckIns.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 92.0
        }
        
        return 108.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaCheckIn", for: indexPath)
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 3
            
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as? CheckInTableViewCell
        
       
        
        var imagenURL:String = ""
        
        var item: GeneralTableItem?
        
        if self.tab.tabSeleccionada == 0 {
            
            item = self.listaCercanos[indexPath.row]
            
            cell?.badge.alpha = 1
            cell?.badge.text = item!.badge
            cell?.compartirFacebookButton.isHidden = true
            
            cell?.distancia.text = item!.ditancia
        } else{
            item = self.listaMisCheckIns[indexPath.row]
            
            cell?.badge.alpha = 0
            cell?.badge.text = "0"
            
            if item!.compartir {
                cell?.compartirFacebookButton.isHidden = false
            } else {
                cell?.compartirFacebookButton.isHidden = true
            }
            
            cell?.distancia.text = "\(item!.ditancia) · \(item!.tiempo)"
        }
        
        imagenURL = item!.avatar
        
        cell?.nombre.text = item!.nombre
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let lugar = NSMutableAttributedString(string: "\( item!.lugar): ", attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue-Bold", size: 12)!, NSForegroundColorAttributeName: ColoresTexto.Pink, NSParagraphStyleAttributeName: paragraphStyle ])
        
        let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSForegroundColorAttributeName: ColoresTexto.Pink, NSParagraphStyleAttributeName: paragraphStyle ])
        
        lugar.append(descripcion)
        cell?.texto.attributedText = lugar
        
        cell?.texto.lineBreakMode = .byTruncatingTail
        
        let imagen =  self.imagenCache[imagenURL];
        cell?.foto.image = nil
        
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
                        cell?.foto.image = nil
                        return
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let _imagen = UIImage(data: data!) {
                            
                            let imagen = self.tab.tabSeleccionada == 0 ? Utilerias.aplicarEfectoDifuminacionImagen(_imagen, intensidad: item!.restriccion) : _imagen
                            
                            self.imagenCache[imagenURL] = imagen;
                            
                            if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell {
                                
                                cell.foto.image = imagen
                                
                            }
                        } else {
                            if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell {
                                cell.foto.image = nil
                            }
                        }
                    })
                };
                task.resume()
            } else {
                cell?.foto.image = nil
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                if let cell = tableView.cellForRow(at: indexPath) as? CheckInTableViewCell  {
                    cell.foto.image = imagen
                }
            })
        }
        
        
        
        return cell!
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MostrarHacerCheckIn", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
