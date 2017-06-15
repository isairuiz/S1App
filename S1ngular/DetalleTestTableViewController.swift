//
//  DetalleTestTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 01/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit

class DetalleTestTableViewController: UITableViewController {

    @IBOutlet weak var heightHeaderLabel: NSLayoutConstraint!
    @IBOutlet weak var heightImagenLabel: NSLayoutConstraint!
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var testActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var indiceLabel: UILabel!
    
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var preguntaImagenLabel: UILabel!
    @IBOutlet weak var preguntaImageView: UIImageView!
    @IBOutlet weak var preguntaImagebActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var comenzarTestView: UIView!
    
    @IBOutlet weak var respuestasTableViewCell: UITableViewCell!
    
    var test:Test!
    
    
    var indicePreguntaActual: Int = -1
    var testComenzado:Bool = false
    var testFinalizado:Bool = false
    
    @IBOutlet weak var resultadoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.preguntaLabel.sizeToFit()
        
        self.comenzarTestView.layer.shadowColor = UIColor.black.cgColor
        self.comenzarTestView.layer.shadowOpacity = 0.5
        self.comenzarTestView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.comenzarTestView.layer.shadowRadius = 3
        
        
        self.badgeView.layoutIfNeeded()
        self.badgeView.layer.cornerRadius = self.badgeView.bounds.height / 2
        
        
        
        
        let preguntas: [TestPregunta] = [
            
            TestPregunta(id: 0, pregunta: "Aquí viene la pregunta de cada sección. Se contesta seleccionando una o varias de las opciones, dependiendo el tipo de pregunta.", tipo: .texto, tipoRespuestas: .texto, respuestas: [
                TestRespuesta(id: 0, respuesta: "Respuesta 1", descripcion: "", imagen: ""),
                TestRespuesta(id: 0, respuesta: "Respuesta 2",descripcion: "", imagen: ""),
                TestRespuesta(id: 0, respuesta: "Respuesta 3",descripcion: "", imagen: ""),
                TestRespuesta(id: 0, respuesta: "Respuesta 4",descripcion: "", imagen: ""),
            ]),
            
            TestPregunta(id: 0, pregunta: "Pregunta en la imagen", tipo: .imagen,imagen: "http://kids.nationalgeographic.com/content/dam/kids/photos/animals/Mammals/A-G/gray-wolf-snow.jpg.adapt.945.1.jpg", tipoRespuestas: .texto, respuestas: [
                TestRespuesta(id: 1, respuesta: "Respuesta 1 algo larga pero no tanto como para mamar", descripcion: "", imagen: ""),
                TestRespuesta(id: 2, respuesta: "Respuesta 2 esta mas o menos", descripcion: "", imagen: ""),
                TestRespuesta(id: 3, respuesta: "Respuesta 3", descripcion: "", imagen: "")
            ]),
            
            TestPregunta(id: 0, pregunta: "¿Cual es tu color favorito?", tipo: .texto, tipoRespuestas: .color, respuestas: [
                TestRespuesta(id: 11, color: UIColor.green,descripcion: "", imagen: ""),
                TestRespuesta(id: 12, color: UIColor.magenta,descripcion: "", imagen: ""),
                TestRespuesta(id: 13, color: UIColor.yellow,descripcion: "", imagen: ""),
                TestRespuesta(id: 14, color: UIColor.cyan,descripcion: "", imagen: ""),
                TestRespuesta(id: 15, color: UIColor.red,descripcion: "", imagen: ""),
            ]),
            
            TestPregunta(id: 0, pregunta: "¿De que color es el carro? porque esta es una pregunta muy larga y debería acomodarse el texto", tipo: .imagen, imagen: "http://www.ford.es/cs/BlobServer?blobtable=MungoBlobs&blobcol=urldata&blobheader=image%2Fjpeg&blobwhere=1214507597833&blobkey=id", tipoRespuestas: .color, respuestas: [
                TestRespuesta(id: 13, color: UIColor.yellow,descripcion: "", imagen: ""),
                TestRespuesta(id: 14, color: UIColor.blue,descripcion: "", imagen: ""),
                TestRespuesta(id: 15, color: UIColor.red,descripcion: "", imagen: ""),
                TestRespuesta(id: 15, color: UIColor.green,descripcion: "", imagen: ""),
                ]),
        ]
        
        self.test = Test(id: 1, nombre: "Nombre del test de 2 o + renglones tiene 10px de separación con botón derecha indicador de num preguta", descripcion: "Descripción del Test con explicación sencilla, rápida, divertida y al punto. Descripción del Test con explicación sencilla, rápida, divertida y al punto (...)", tag: "TAG DEL TEST1", costo: 0, recompensa: 0, imagen: "https://memoirsofasoulsista.files.wordpress.com/2013/01/happy-man.jpg", preguntas: preguntas, ambito: "", contestado: false)
        
        
        self.testLabel.text = test.nombre
        self.testLabel.layoutIfNeeded()
        self.testLabel.sizeToFit()
        
        
        self.heightHeaderLabel.constant = self.testLabel.bounds.height + 41
        self.tagLabel.text = test.tag
        
        self.preguntaLabel.text = self.test.descripcion
        self.indiceLabel.text = "0 / \(self.test.preguntas.count)"
        
        self.comenzarTestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.comenzarTest)))
        
        
        
        
        let url:URL = URL(string: test.imagen )!
        let session = URLSession.shared;
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = url;
        request.httpMethod = "GET"
        
        self.testActivityIndicator.startAnimating()
        let task = session.dataTask(with: request as URLRequest){data,response, error in
            
            
            guard data != nil else {
                self.testImageView.image = nil
                DispatchQueue.main.async(execute: { () -> Void in
                    self.testActivityIndicator.stopAnimating()
                })
                return
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let imagen = UIImage(data: data!) {
                    self.testImageView.image = imagen
                    
                } else {
                    self.testImageView.image = nil
                }
                self.testActivityIndicator.stopAnimating()
            })
        };
        task.resume()
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Header
        if indexPath.row == 0 {
            return 200
        }
        
        // Pregunta
        if  indexPath.row == 1 && !testComenzado && !self.testFinalizado{
            
            return self.preguntaLabel.bounds.height + 16
        }
        
        if !self.testFinalizado && testComenzado && indexPath.row == 1 && self.test.preguntas[self.indicePreguntaActual].tipo == .texto  {
            
            return self.preguntaLabel.bounds.height + 16
        }
        
        // Pregunta con imagen
        if !self.testFinalizado &&  indexPath.row == 2 && testComenzado && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipo == .imagen  {
            return 200
        }
        
        // Comenzar el test
        if indexPath.row == 3 && !testComenzado && !self.testFinalizado{
            return 78
        }
        
        
        // aquí va a depender de las respuestas
        
        if !self.testFinalizado && indexPath.row == 4 && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipoRespuestas == .texto  {
            let total = CGFloat(self.test.preguntas[self.indicePreguntaActual].respuestas.count)
            return (total * 45.0) + (total * 16) + 16.0
        }
        
        if !self.testFinalizado && indexPath.row == 4 && testComenzado && self.test.preguntas[self.indicePreguntaActual].tipoRespuestas == .color  {
           
            
            let total = CGFloat(self.test.preguntas[self.indicePreguntaActual].respuestas.count)
            
            return ceil(total / 2) * (self.tableView.bounds.width / 2)
        }
        
        if indexPath.row == 5 && self.testFinalizado {
            return 44
        }
        
        if indexPath.row == 6 && self.testFinalizado {
            
            return self.resultadoLabel.bounds.height + 16
        }
        
         return 0
        // return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if testComenzado {
            return false
        }
        return true
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    
    // MARK: - Actions y Eventos
    
    func comenzarTest() {
        self.testComenzado = true
        //self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        self.parent?.navigationItem.leftBarButtonItem?.isEnabled = false
        self.siguientePregunta()
    }
    
    func siguientePregunta() {
        
        self.indicePreguntaActual += 1
        
        guard self.indicePreguntaActual < self.test.preguntas.count else {
            self.testFinalizado = true
            self.parent?.navigationItem.leftBarButtonItem?.isEnabled = false
            _ = self.navigationController?.popViewController(animated: true)
            
            // Hay qu epensar en algo
            self.resultadoLabel.text = "Este es el resultado final final OK OK"
            self.resultadoLabel.sizeToFit()
            self.tableView.reloadData()
            return
        }
        
        let pregunta = self.test.preguntas[self.indicePreguntaActual]
        
        if pregunta.tipo == .texto {
            self.preguntaLabel.text = pregunta.pregunta
            self.preguntaLabel.sizeToFit()
        } else {
            self.preguntaImagenLabel.text = pregunta.pregunta
            self.preguntaImagenLabel.layoutIfNeeded()
            self.preguntaImagenLabel.sizeToFit()
            self.heightImagenLabel.constant = self.preguntaImagenLabel.bounds.height + 16
            
            
            let url:URL = URL(string: pregunta.imagen )!
            let session = URLSession.shared;
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = url;
            request.httpMethod = "GET"
            
            self.preguntaImagebActivityIndicator.startAnimating()
            let task = session.dataTask(with: request as URLRequest){data,response, error in
                
                
                guard data != nil else {
                    self.preguntaImageView.image = nil
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.preguntaImagebActivityIndicator.stopAnimating()
                    })
                    return
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if let imagen = UIImage(data: data!) {
                        self.preguntaImageView.image = imagen
                        
                    } else {
                        self.preguntaImageView.image = nil
                    }
                    self.preguntaImagebActivityIndicator.stopAnimating()
                })
            };
            task.resume()
            
            
        }
        
        self.indiceLabel.text = "\(self.indicePreguntaActual + 1) / \(self.test.preguntas.count)"
        
        
        self.respuestasTableViewCell.contentView.subviews.forEach({ $0.removeFromSuperview()  })
        
        var i = CGFloat(0)
        var line = CGFloat(0)
        for respuesta in pregunta.respuestas {
            if pregunta.tipoRespuestas == .texto {
                let button = ClearButtonRounded(frame: CGRect(x: 8.0, y: 45 * i + 16 * (i + 1), width: self.tableView.bounds.width - 16, height: 45))
                
                button.setTitle(respuesta.respuesta, for: UIControlState.normal)
                //button.id = respuesta.id
                
                button.tag = respuesta.id
                
                button.addTarget(self, action: #selector(self.seleccionarRespuesta(sender:)), for: UIControlEvents.touchUpInside)
                self.respuestasTableViewCell.contentView.addSubview(button)
            }
            
            if pregunta.tipoRespuestas == .color {
                let side = self.tableView.bounds.width / 2
                
                let x = (Int(i) + 1) % 2 == 0 ? side : 0.0
                if i > 1 {
                    line = x == 0.0 ? line + 1 : line
                }
                
                let view = UIView(frame: CGRect(x: x, y: line * side, width: side, height: side))
                view.backgroundColor = respuesta.color
                view.tag = respuesta.id
                
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarColor(sender:))))
                self.respuestasTableViewCell.contentView.addSubview(view)
                
            }
            
            i += 1
        }
        
        self.tableView.reloadData()
        
        
        
    }
    
    func seleccionarRespuesta(sender: UIView){
        print(sender.tag)
        
        self.siguientePregunta()
    }
    func seleccionarColor(sender: UIGestureRecognizer){
        print(sender.view?.tag)
        
        self.siguientePregunta()
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
