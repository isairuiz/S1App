//
//  S1ngularesTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class S1ngularesTableViewController: UITableViewController {
    
    var tab: TabView!
    
    var imagenCache = [String: UIImage]()
    var listaChat:[GeneralTableItem] = []
    var listaNuevos:[GeneralTableItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain ]
        
        tab = TabView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 66))
        
        tab.actualizarTextoBotones("CHAT", derecha: "NUEVOS")
        tab.botonIzquierda!.addTarget(self, action: #selector(self.cambiarPrimerTab), for: UIControlEvents.touchUpInside)
        tab.botonDerecha!.addTarget(self, action: #selector(self.cambiarSegundoTab), for: UIControlEvents.touchUpInside)
        
        
        listaNuevos = [
            GeneralTableItem(id: 18, nombre: "TEST luna", distancia: "", tiempo: "", lugar: "", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua.", avatar: "http://www.meganfox.com/wp-content/uploads/2014/01/5.jpg", badge: "", compartir: false, resaltar: false, restriccion: 50),
            
            GeneralTableItem(id: 19, nombre: "TEST sam", distancia: "", tiempo: "", lugar: "", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua", avatar: "http://ell.h-cdn.co/assets/16/07/980x490/landscape-1455813161-elle-henrycavill.jpg", badge: "", compartir: false, resaltar: false, restriccion: 50)
        ]
        
        
        listaChat = [
            
            
            GeneralTableItem(id: 18, nombre: "TEST Luna", distancia: "37 metros", tiempo: "2:30 hrs", lugar: "", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua", avatar: "http://www.stereomar94fm.com.ve/wp-content/uploads/2016/05/ladygaga-500x375.jpg", badge: "2", compartir: false, resaltar: false, restriccion: 10),
            
            GeneralTableItem(id: 17, nombre: "TEST Angel Ruiz", distancia: "626 metros", tiempo: "7:16 hrs", lugar: "De Barbas", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua", avatar: "http://pixel.nymag.com/imgs/daily/vulture/2016/01/19/19-zac-efron-tweet-mlk.w529.h529.jpg", badge: "4", compartir: false, resaltar: false, restriccion: 0),
            
            
            
            GeneralTableItem(id: 19, nombre: "TEST Sam", distancia: "2 metros", tiempo: "8:58 hrs", lugar: "", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua", avatar: "http://segnorasque.com/wp-content/uploads/2016/06/jolie.jpeg", badge: "", compartir: false, resaltar: false, restriccion: 20),
            
            GeneralTableItem(id: 1, nombre: "Pharrell Williams", distancia: "3 km", tiempo: "1 día", lugar: "Chuti de terán", descripcion: "Primeros caracteres de la conversacion. De exceder el espacio, continuará con esto se puede hacer muchas cosas y entonces lalala porque bla bla bla y asi nos vamos al mundo mundial jua jua jua", avatar: "http://media.dlccdn.com/artistas/p/pharrell-williams/pharrell-williams_o.jpg", badge: "85", compartir: false, resaltar: true, restriccion: 30)
            
        
            
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
        return true
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tab
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.tab.tabSeleccionada == 0 {
            return self.listaChat.count
        }
        
        return self.listaNuevos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as? S1ngularesTableViewCell
        
        // Configure the cell...
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        var imagenURL:String = ""
        
        var item: GeneralTableItem?
        
        if self.tab.tabSeleccionada == 0 {
            
            item = self.listaChat[(indexPath as NSIndexPath).row]
            
            cell?.badge.alpha = 1
            cell?.badge.text = item!.badge
            
            
            cell?.distancia.text = item!.ditancia
            if item!.resaltar {
                cell?.actualizarTipo(3)
            } else {
                if item!.badge == ""  {
                    cell?.actualizarTipo(2)
                } else {
                    cell?.actualizarTipo(1)
                }
                
            }
            
            
        } else{
            item = self.listaNuevos[(indexPath as NSIndexPath).row]
            
            cell?.badge.alpha = 0
            cell?.badge.text = "0"
            cell?.distancia.text = ""
            
            cell?.actualizarTipo(2)
            
            
        }
        
        imagenURL = item!.avatar
        
        cell?.nombre.text = item!.nombre
        
        
        let descripcion = NSMutableAttributedString(string: item!.descripcion, attributes: [NSFontAttributeName :  UIFont(name: "HelveticaNeue", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle ])
        cell?.texto.attributedText = descripcion
        cell?.texto.lineBreakMode = .byTruncatingTail
        
        
        
        
        
        let imagen =  self.imagenCache[imagenURL];
        cell?.foto.image = UIImage(named: "Avatar")
        
        if(imagen == nil){
            // Si la imagen no exite hay que descargarla
            if item?.avatar != "" {
                let url:URL = URL(string: "\(item!.avatar)?\( arc4random_uniform(100) )" )!
                let session = URLSession.shared;
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = url;
                request.httpMethod = "GET"
                
                
                let task = session.dataTask(with: request as URLRequest){data,response, error in
                   
                    guard data != nil else {
                        cell?.foto.image = UIImage(named: "Avatar")
                        return
                        
                    }
                    
                    
                    
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let _imagen = UIImage(data: data!) {
                            let imagen = Utilerias.aplicarEfectoDifuminacionImagen(_imagen, intensidad: item!.restriccion)
                            self.imagenCache[imagenURL] = imagen;
                            if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                cell.foto.image = imagen
                                
                            }
                        } else {
                            if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                                cell.foto.image = UIImage(named: "Avatar")
                                
                            }
                        }
                    })
                };
                task.resume()
            } else {
                cell?.foto.image = UIImage(named: "Avatar")
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let cell = tableView.cellForRow(at: indexPath) as? S1ngularesTableViewCell {
                    cell.foto.image = imagen
                    
                }
                
                
            })
        }
        
        
        
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.tab.tabSeleccionada == 1 {
            let indexPath = tableView.indexPathForSelectedRow
            var item: GeneralTableItem?
            item = self.listaNuevos[(indexPath! as NSIndexPath).row]
            DataUserDefaults.setIdVerPerfil(id: (item?.id)!)
            performSegue(withIdentifier: "gotoVerPerfil", sender: nil)
        }else{
            let indexPath = tableView.indexPathForSelectedRow
            var item: GeneralTableItem?
            item = self.listaChat[(indexPath! as NSIndexPath).row]
            DataUserDefaults.setIdVerPerfil(id: (item?.id)!)
            performSegue(withIdentifier: "gotoMesajesChat", sender: nil)
        }
    }
    
    // MARK: - Acciones y eventos
    
    func cambiarPrimerTab (){
       
        /*self.tableView.beginUpdates()
        self.tableView.endUpdates()*/
        self.tableView.reloadData()
        
        
    }
    
    func cambiarSegundoTab (){
        
       
        
        /*self.tableView.beginUpdates()
        self.tableView.endUpdates()*/
        self.tableView.reloadData()
        
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
