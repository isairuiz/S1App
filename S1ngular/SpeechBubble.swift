//
//  SpeechBubble.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 31/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//
import UIKit
import AVFoundation

class SpeechBubble: UIView, AVAudioPlayerDelegate {
    
    var color:UIColor = UIColor.gray
    var labelChatText: UILabel?
    var data: ChatBubbleData?
    let padding: CGFloat = 10.0
    var player:AVAudioPlayer!
    var urlCorrect = NSURL()
    var isPlaying : Bool = false
    var playbutton : UIButton?
    var audioProgress:UISlider?
    var timer:Timer?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: SpeechBubble.framePrimary(type: .Mine))
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }
    
    
    
    required convenience init(withData data: ChatBubbleData, eventTarget: AnyObject) {
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
            
            var baseUrl = Constantes.BASE_URL
            if data.fromNetwork{
                baseUrl += data.soundUrlString!
                urlCorrect = NSURL(string: baseUrl)!
            }else{
                urlCorrect = NSURL(string: data.soundUrlString!)!
            }
            debugPrint("Url de audio: \(urlCorrect)")
            
            playbutton = UIButton(frame: CGRect(x: startX, y: 1, width: 34, height: 34))
            playbutton?.setImage(UIImage(named: "play_audio"), for: .normal)
            playbutton?.isUserInteractionEnabled = true
            self.playbutton?.addTarget(self, action: #selector(self.downloadFileFromURL), for: UIControlEvents.touchUpInside)
            
            self.addSubview(playbutton!)
            
            audioProgress = UISlider(frame: CGRect(x: (playbutton?.frame.width)!+5, y: 10, width: self.frame.width - (playbutton?.frame.width)!-5, height: 15))
            audioProgress?.minimumValue = 0
            audioProgress?.maximumValue = 100
            self.addSubview(audioProgress!)
            self.frame = CGRect(x: xWithSound, y: 5, width: maxWidth, height: 55)
            
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
    
    func downloadFileFromURL(){
        if (self.data?.fromNetwork)!{
            var downloadTask:URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: urlCorrect as URL, completionHandler: { [weak self](URL, response, error) -> Void in
                self?.play(URL!)
            })
            
            downloadTask.resume()
        }else{
            self.play(self.urlCorrect as URL)
        }
        
        
    }
    
    func trackAudio() {
        var normalizedTime = Float(player.currentTime * 100.0 / player.duration)
        audioProgress?.value = normalizedTime
    }
    
    func play(_ url:URL) {
        
        print("playing \(url)")
        if !isPlaying{
            isPlaying = true;
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(trackAudio), userInfo: nil, repeats: true)
            do {
                DispatchQueue.main.async() { () -> Void in
                    self.playbutton?.setImage(UIImage(named: "pause_audio"), for: .normal)
                }
                self.player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.volume = 1.0
                player.delegate = self
                player.play()
                RunLoop.main.add(self.timer!, forMode: .commonModes)
                
            } catch let error as NSError {
                DispatchQueue.main.async() { () -> Void in
                    self.timer?.invalidate()
                    self.playbutton?.setImage(UIImage(named: "play_audio"), for: .normal)
                    self.audioProgress?.value = 0
                    self.audioProgress?.minimumValue = 0
                    self.audioProgress?.maximumValue = 100
                }
                self.player = nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
        }else{
            DispatchQueue.main.async() { () -> Void in
                self.playbutton?.setImage(UIImage(named: "play_audio"), for: .normal)
                self.timer?.invalidate()
                self.audioProgress?.value = 0
                self.audioProgress?.minimumValue = 0
                self.audioProgress?.maximumValue = 100
            }
            isPlaying = false;
            print("stop playing")
            player.stop()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            debugPrint("Termine de sonar!")
            isPlaying = false;
            
            DispatchQueue.main.async() { () -> Void in
                self.timer?.invalidate()
                self.audioProgress?.value = 0
                self.audioProgress?.minimumValue = 0
                self.audioProgress?.maximumValue = 100
                self.playbutton?.setImage(UIImage(named: "play_audio"), for: .normal)
            }
        }
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

