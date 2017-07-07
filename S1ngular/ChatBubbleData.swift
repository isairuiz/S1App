//
//  ChatBubbleData.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 01/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import Foundation
import UIKit

enum BubbleDataType: Int{
    case Mine = 0
    case Opponent
}

/// DataModel for maintaining the message data for a single chat bubble
class ChatBubbleData {
    
    // 2.Properties
    var text: String?
    var image: UIImage?
    var date: NSDate?
    var type: BubbleDataType
    var soundUrlString: String?
    var fromNetwork:Bool
    
    
    // 3. Initialization
    init(text: String?,image: UIImage?,date: NSDate?,soundUrlString:String?, type:BubbleDataType = .Mine, fromNetwork:Bool) {
        // Default type is Mine
        self.text = text
        self.image = image
        self.date = date
        self.type = type
        self.soundUrlString = soundUrlString
        self.fromNetwork = fromNetwork
    }
}
