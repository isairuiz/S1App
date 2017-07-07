//
//  ChatTableViewCell.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 31/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var cellContainer: UIView!
    var theBubbleView: UIView?
    var itemData: MessageItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        debugPrint("hola desde la celda: \(itemData?.text)")
        debugPrint("hola desde la celdax2: \(itemData?.audioUrl)")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
