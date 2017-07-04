//
//  ChatS1TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChatS1TableViewController: UITableViewController {
    
    var listaMessages:[MessageItem] = []
    var currentIdUsuario = Int()
    var idPersona = Int()
    var scrollView = UIScrollView()
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    var mensajesChat : [JSON] = []
    
    var isPaginando : Bool = false
    var numPaginado : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIdUsuario = DataUserDefaults.getCurrentId()
        idPersona = 19
        scrollView.delegate = self
        
    }
    
    func keyboardWillHide() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeKeyboardNotif"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keyboardWillHide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageCell", for: indexPath as IndexPath) as! ChatTableViewCell
        
        var item: MessageItem
        item = self.listaMessages[(indexPath as NSIndexPath).row]
        
        /*Clear view on refresh*/
        for view in cell.messageBubble.subviews {
            view.removeFromSuperview()
        }
        let messageType = item.id == currentIdUsuario ? BubbleDataType.Mine : BubbleDataType.Opponent
        let chatBubbleData = ChatBubbleData(text: item.text, image: item.image, date: item.date, type: messageType, soundUrlString: "")
        let chatBubbleMessage = SpeechBubble(withData: chatBubbleData)
        cell.messageBubble.addSubview(chatBubbleMessage)
        
        let horizontalConstraint = NSLayoutConstraint(item: chatBubbleMessage, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell.messageBubble, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: chatBubbleMessage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell.messageBubble, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                
        cell.cellContainer.addConstraint(horizontalConstraint)
        cell.cellContainer.addConstraint(verticalConstraint)
        

        debugPrint("el index path row:\(indexPath.row)")
        if indexPath.row == self.listaMessages.count-1{
            self.scrollView.scrollToEdge(position: .Bottom, animated: false)
        }
        
        return cell
        
    }
    
    func scrollToBottom(){
        self.tableViewScrollToBottom(animated: false)
    }
    
    func ListarMensajesChat(paginado:Int){
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        Utilerias.setCustomLoadingScreen(loadingView: loadingView, tableView: self.tableView, loadingLabel: loadingLabel, spinner: spinner)
        var url:String = Constantes.LISTAR_MENSAJES_CHAT
        url += "id=\(DataUserDefaults.getIdVerPerfil())"
        url += "&paginado=\(paginado)"
        debugPrint(url)
        Alamofire.request(url, headers: self.headers)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if(status){
                        if !json["mensajes"].isEmpty{
                            self.mensajesChat = self.mensajesChat.reversed()
                            self.mensajesChat += json["mensajes"].arrayValue
                            self.mensajesChat = self.mensajesChat.reversed()
                            self.listaMessages.removeAll()
                            for mensaje in self.mensajesChat{
                                //let id = mensaje["id"].int
                                //let fecha = mensaje["fecha"].string
                                let idEmisor = mensaje["singular1"].int
                                let idReceptor = mensaje["singular2"].int
                                let contenido = mensaje["contenido"].string
                                //let _ = mensaje["leido"].bool
                                self.listaMessages.append(
                                    MessageItem(text: contenido!, image: nil, date: NSDate(), id: idReceptor!)
                                )
                            }
                            self.isPaginando = false
                            self.tableView.reloadData()
                            if self.numPaginado >= 2{
                                
                            }else{
                                self.tableViewScrollToBottom(animated: false)
                            }
                            
                        }else{
                            self.numPaginado -= 1
                        }
                        self.isPaginando = false
                        self.tableView.reloadData()
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                    }else{
                        Utilerias.removeCustomLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner)
                        if let mensaje = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error", message: mensaje)
                        }
                        
                    }
                }
        }
    }
    
    func enviarMensaje(mensaje:String,receptor:Int){
        
        let parameters: Parameters = ["id_singular": receptor,
                                      "contenido": mensaje]
        Alamofire.request(Constantes.ENVIAR_MENSAJE, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
            .responseJSON{
                response in
                let json = JSON(response.result.value)
                debugPrint(json)
                if let status = json["status"].bool{
                    if status{
                        let id = json["id"].int
                        self.pintarMensajeEnviado(mensaje:mensaje,id: receptor)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unlockTextField"), object: nil)
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unlockTextField"), object: nil)
                        if let mensaje = json["mensaje_plain"].string{
                            self.showAlertWithMessage(title: "Error", message: mensaje)
                        }
                    }
                }
        }
    }
    
    func pintarMensajeEnviado(mensaje:String, id:Int){
        self.listaMessages.append(MessageItem(text: mensaje, image: nil, date: NSDate(), id: id))
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.listaMessages.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        self.tableViewScrollToBottom(animated: false)

    }
    
    func showAlertWithMessage(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrolledTop = scrollView.isScrolledToEdge(edge: .Top)
        if isScrolledTop{
            debugPrint("Numero de mensajes: \(self.listaMessages.count)")
            if self.listaMessages.count >= 14{
                if !self.isPaginando{
                    self.isPaginando = true
                    self.numPaginado += 1
                    self.ListarMensajesChat(paginado: self.numPaginado)
                    debugPrint("Puedo paginar!!!")
                }
            }else{
                debugPrint("No Puedo paginar aun!")
            }
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        keyboardWillHide()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mensajesChat.removeAll()
        self.listaMessages.removeAll()
        self.ListarMensajesChat(paginado: 1)
    }
    
    
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

}


enum UIScrollViewEdge { case Top, Bottom }

extension UIScrollView {
    
    func scrollToEdge(position: UIScrollViewEdge, animated: Bool) {
        let offset = verticalContentOffsetForEdge(edge: position)
        let offsetPoint = CGPoint(x: contentOffset.x, y: offset)
        setContentOffset(offsetPoint, animated: animated)
    }
    
    func isScrolledToEdge(edge: UIScrollViewEdge) -> Bool {
        let offset = contentOffset.y
        let offsetForEdge = verticalContentOffsetForEdge(edge: edge)
        switch edge {
        case .Top: return offset <= offsetForEdge
        case .Bottom: return offset >= offsetForEdge
        }
    }
    
    private func verticalContentOffsetForEdge(edge: UIScrollViewEdge) -> CGFloat {
        switch edge {
        case .Top: return 0 - contentInset.top
        case .Bottom: return contentSize.height + contentInset.bottom - bounds.height
        }
    }
    
}
