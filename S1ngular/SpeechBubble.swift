//
//  SpeechBubble.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 31/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//
import UIKit

class SpeechBubble: UIView {
    
    var color:UIColor = UIColor.gray
    var labelChatText: UILabel?
    var data: ChatBubbleData?
    let padding: CGFloat = 10.0
    var playbutton : UIButton?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    
    
    required convenience init(withData data: ChatBubbleData) {
        self.init(frame: SpeechBubble.framePrimary(type: data.type))
        self.data = data
        
        if data.type == .Mine{
            color = ColoresTexto.TXTMain
        }else{
            color = ColoresTexto.TXTSecondary
        }
        
        let paddingFactor: CGFloat = 0.02
        let sidePadding = UIScreen.main.bounds.width * paddingFactor
        let startX = padding
        let startY:CGFloat = 0.0
        
        if !(data.soundUrlString?.isEmpty)!{
            //Cuando data trae multimedia
            let maxWidth = UIScreen.main.bounds.width * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
            let xWithSound: CGFloat = data.type == .Mine ? UIScreen.main.bounds.width * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
            
            playbutton = UIButton(type: .custom)
            playbutton?.frame = CGRect(x: startX, y: startY, width: self.frame.width - 2 * startX, height: 5)
            playbutton?.isUserInteractionEnabled = true
            //playbutton?.actions(forTarget: Selector(), forControlEvent: UIControlEvents.touchUpInside)
        
            playbutton?.setImage(UIImage(named: ""), for: .normal)
            
            
            self.frame = CGRect(x: xWithSound, y: 10, width: maxWidth, height: 40)
        }else{
            //Cuando es un simple mensaje sin multimedia
            
            labelChatText = UILabel(frame: CGRect(x: startX, y: startY, width: self.frame.width - 2 * startX, height: 5))
            labelChatText?.textAlignment = data.type == .Mine ? .right : .left
            labelChatText?.font = UIFont(name: "BrandonGrotesque-Medium", size: 16)
            labelChatText?.textColor = data.type == .Mine ? ColoresTexto.TXTSecondary : ColoresTexto.TXTMain
            labelChatText?.numberOfLines = 0
            labelChatText?.lineBreakMode = NSLineBreakMode.byTruncatingTail
            labelChatText?.text = data.text
            labelChatText?.sizeToFit()
            
            self.addSubview(labelChatText!)
            
            var viewHeight: CGFloat = 0.0
            var viewWidth: CGFloat = 0.0
            
            viewHeight = (labelChatText?.frame.maxY)! + padding
            viewWidth = (labelChatText?.frame.width)! + ((labelChatText?.frame.minX)! + padding)
            
            
            
            
            let NewStartX: CGFloat = data.type == .Mine ? UIScreen.main.bounds.width * (CGFloat(1.0) - paddingFactor) - viewWidth : sidePadding
            
            self.frame = CGRect(x: NewStartX, y: 10, width: viewWidth, height: viewHeight+15)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let rounding:CGFloat = rect.width * 0.00
        
        //Draw the main frame
        
        let bubbleFrame = CGRect(x: rect.minX, y: 0, width: rect.width, height: rect.height-20)
        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 10, height: 10))
        
        //Color the bubbleFrame
        
        color.setStroke()
        color.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        //Add the point
        
        let context = UIGraphicsGetCurrentContext()
        
        //Start the line
        
        context!.beginPath()
        
        if self.data?.type == BubbleDataType.Mine{
            context?.move(to: CGPoint(x:bubbleFrame.maxX - bubbleFrame.width * 1/6, y:bubbleFrame.maxY))
            //Draw a rounded point
            context?.addArc(tangent1End: CGPoint(x:rect.maxX - rect.maxX * 1/6,y:bubbleFrame.maxY+15), tangent2End: CGPoint(x:bubbleFrame.minX,y:bubbleFrame.minY), radius: rounding)
            //Close the line
            context?.addLine(to: CGPoint(x:bubbleFrame.maxX - bubbleFrame.width * 2/7,y:bubbleFrame.maxY))
            
            context!.closePath()
            context!.setFillColor(ColoresTexto.TXTMain.cgColor)
            context?.fillPath();
        }else{
            context?.move(to: CGPoint(x:bubbleFrame.minX + bubbleFrame.width * 1/6, y:bubbleFrame.maxY))
            
            //Draw a rounded point
            context?.addArc(tangent1End: CGPoint(x:rect.maxX * 1/6,y:bubbleFrame.maxY+15), tangent2End: CGPoint(x:bubbleFrame.maxX,y:bubbleFrame.minY), radius: rounding)
            
            context?.addLine(to: CGPoint(x:bubbleFrame.minX + bubbleFrame.width * 2/7,y:bubbleFrame.maxY))
            
            context!.closePath()
            context!.setFillColor(ColoresTexto.TXTSecondary.cgColor)
            context?.fillPath();
            
        }
        
        
        
    }
    
    
    class func framePrimary(type:BubbleDataType) -> CGRect{
        let paddingFactor: CGFloat = 0.02
        let sidePadding = UIScreen.main.bounds.width * paddingFactor
        let maxWidth = UIScreen.main.bounds.width * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
        let startX: CGFloat = type == .Mine ? UIScreen.main.bounds.width * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
        return CGRect(x:startX, y:10, width:maxWidth, height:70) // 5 is the primary height before drawing starts
    }
}

