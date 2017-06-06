//
//  ChatS1TableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class ChatS1TableViewController: UITableViewController {
    
    var listaMessages:[MessageItem] = []
    var currentIdUsuario = Int()
    var idPersona = Int()
    var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIdUsuario = DataUserDefaults.getCurrentId()
        idPersona = 19
        scrollView.delegate = self
        listaMessages = [
            MessageItem(text: "hey!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "what no puedo creerlo xdxdxdxdxdxdxdx!!!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "no quiero !!!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "este puede ser un texto muy grande pero vamos a ver como queda y si hace el resize y sino ni modos mejor hacemos otra cosa y nos vmos a dormir y mañana tendremos junta okokokokokokokokokokokokokoko!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "ñoo dasldkaldkjaldkajldjalkdlaksjdlkasjdlkjaslkdjasldjaslkdjlaksjdklasjdlaksjdlas!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "hey!", image: nil, date: NSDate(), id:17),
            MessageItem(text: "what no puedo creerlo xdxdxdxdxdxdxdx!!!", image: nil, date: NSDate(),id: 17),
            MessageItem(text: "no quiero !!!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "este puede ser un texto muy grande pero vamos a ver como queda y si hace el resize y sino ni modos mejor hacemos otra cosa y nos vmos a dormir y mañana tendremos junta okokokokokokokokokokokokokoko!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "ñoo dasldkaldkjaldkajldjalkdlaksjdlkasjdlkjaslkdjasldjaslkdjlaksjdklasjdlaksjdlas!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "hey!", image: nil, date: NSDate(), id:17),
            MessageItem(text: "what no puedo creerlo xdxdxdxdxdxdxdx!!!", image: nil, date: NSDate(),id: 17),
            MessageItem(text: "no quiero !!!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "este puede ser un texto muy grande pero vamos a ver como queda y si hace el resize y sino ni modos mejor hacemos otra cosa y nos vmos a dormir y mañana tendremos junta okokokokokokokokokokokokokoko!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "ñoo dasldkaldkjaldkajldjalkdlaksjdlkasjdlkjaslkdjasldjaslkdjlaksjdklasjdlaksjdlas!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "hey!", image: nil, date: NSDate(), id:17),
            MessageItem(text: "what no puedo creerlo xdxdxdxdxdxdxdx!!!", image: nil, date: NSDate(),id: 17),
            MessageItem(text: "no quiero !!!", image: nil, date: NSDate(), id: 17),
            MessageItem(text: "este puede ser un texto muy grande pero vamos a ver como queda y si hace el resize y sino ni modos mejor hacemos otra cosa y nos vmos a dormir y mañana tendremos junta okokokokokokokokokokokokokoko!!!", image: nil, date: NSDate(), id: 19),
            MessageItem(text: "heyd,askjdlkajlskdjalkdjlakjlkdajls!!!", image: nil, date: NSDate(), id: 19)
            
        ]
        
        
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
        let chatBubbleData = ChatBubbleData(text: item.text, image: item.image, date: item.date, type: messageType)
        let chatBubbleMessage = SpeechBubble(withData: chatBubbleData)
        cell.messageBubble.addSubview(chatBubbleMessage)
        
        let horizontalConstraint = NSLayoutConstraint(item: chatBubbleMessage, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell.messageBubble, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: chatBubbleMessage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell.messageBubble, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                
        cell.cellContainer.addConstraint(horizontalConstraint)
        cell.cellContainer.addConstraint(verticalConstraint)
        
        debugPrint("/********************************************************************************************************************************************************************************************************************************/")
        debugPrint("tantos mensajes:\(self.listaMessages.count)")
        debugPrint("tantos mensajes menos 1:\(self.listaMessages.count-1)")
        debugPrint("el index path row:\(indexPath.row)")
        if indexPath.row == self.listaMessages.count-1{
            self.scrollView.scrollToEdge(position: .Bottom, animated: true)
        }
        
        return cell
        
    }
    
    
    func enviarMensaje(mensaje:String){
        pintarMensajeEnviado(mensaje:mensaje)
    }
    
    func pintarMensajeEnviado(mensaje:String){
        self.listaMessages.append(MessageItem(text: mensaje, image: nil, date: NSDate(), id: 17))
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.listaMessages.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        self.tableViewScrollToBottom(animated: false)

    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrolledTop = scrollView.isScrolledToEdge(edge: .Top)
        if isScrolledTop{
            debugPrint("estoy en top!!!")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
