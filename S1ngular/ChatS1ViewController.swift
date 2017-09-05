//
//  ChatS1ViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class ChatS1ViewController: UIViewController,UITextFieldDelegate, AVAudioRecorderDelegate{
    @IBOutlet weak var subtituloView: UIView!
    @IBOutlet weak var subtituloTexto: UILabel!
    @IBOutlet weak var profilePersona: UIBarButtonItem!
    @IBOutlet weak var bloquearBarButton: UIBarButtonItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var audioButton: UIImageView!
    @IBOutlet weak var mensajeTextField: UITextField!
    @IBOutlet weak var infoRecord: UILabel!
    
    
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var meterTimer:Timer!
    var soundFileURL:URL!
    
    
    let imageTestUrl = "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg"
    
    var imageTes = UIImageView()
    var bloquearButton = UIButton()
    var tapViewImage = UIGestureRecognizer()
    var audioTapView = UIGestureRecognizer()
    var idVerPerfil = Int()
    
    var childViewController = ChatS1TableViewController()
    
    let jsonPerfilString = DataUserDefaults.getJsonPerfilPersona()
    var jsonPerfilObject : JSON?
    
    var idReceptor = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idVerPerfil = DataUserDefaults.getIdVerPerfil()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 24)!, NSForegroundColorAttributeName: ColoresTexto.TXTMain]
        
        // Borramos la line inferior del Navigationbar para que se una al subtitulo
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.subtituloView.layer.shadowColor = UIColor.black.cgColor
        self.subtituloView.layer.shadowOpacity = 0.5
        self.subtituloView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.subtituloView.layer.shadowRadius = 3
        // Do any additional setup after loading the view.
        
        //POniendo la imagen de perfil de la otra persona en el navigation bar
        imageTes.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageTes.clipsToBounds = true
        imageTes.contentMode = .scaleAspectFit
        imageTes.layer.cornerRadius = imageTes.frame.size.width / 2;
        
        self.idReceptor = DataUserDefaults.getIdVerPerfil()
        
        if let dataFromString = jsonPerfilString.data(using: .utf8, allowLossyConversion: false){
            jsonPerfilObject = JSON(data: dataFromString)
            debugPrint(dataFromString)
            if let nombre = jsonPerfilObject?["nombre"].string{
                subtituloTexto.text = nombre
                DataUserDefaults.setNombrePersona(nombre: nombre)
            }
            
            let foto_visible = jsonPerfilObject?["foto_visible"].floatValue
            
            
            if let imagen = jsonPerfilObject?["imagen"].string
            {
                var fotoUrl = String()
                
                if !(imagen.isEmpty){
                    fotoUrl = Constantes.BASE_URL
                    fotoUrl += imagen
                    imageTes.downloadedFrom(link: fotoUrl,withBlur:true,maxBlur:foto_visible!)
                }else{
                    imageTes.image = UIImage(named: "UsuarioIcon")
                }
            }
            
            
        }
        
        
        tapViewImage = UITapGestureRecognizer(target: self, action: #selector(self.gotoPerfilPersona(sender:)))
        tapViewImage.cancelsTouchesInView = false
        imageTes.addGestureRecognizer(tapViewImage)
        profilePersona.customView = imageTes
        
        
        //Audio tap button
        audioTapView = UITapGestureRecognizer(target: self, action: #selector(self.startStopRecording(sender:)))
        audioButton.addGestureRecognizer(audioTapView)
        
        setSessionPlayback()
        
        
        //Poniendo el boton de bloquear en el navigation bar
        bloquearButton.frame = CGRect(x:0,y:0,width:75,height:30)
        bloquearButton.backgroundColor = UIColor.white
        bloquearButton.layer.cornerRadius = bloquearButton.bounds.size.height/2
        let NormalTitle = NSAttributedString(string: "BLOQUEAR",                                        attributes: [NSFontAttributeName: UIFont(name: "BrandonGrotesque-Light", size: 13)!,NSForegroundColorAttributeName : Colores.BGPink])
        bloquearButton.setAttributedTitle(NormalTitle, for: .normal)
        bloquearButton.titleLabel?.textAlignment = NSTextAlignment.center
        bloquearButton.addTarget(self, action:#selector(gotoBloquear(sender:)), for: .touchUpInside)
        bloquearBarButton.customView = bloquearButton
        
        mensajeTextField.delegate = self
        mensajeTextField.returnKeyType = .send
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardDidShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardDidHide, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(tryCloseKeyboard), name: NSNotification.Name(rawValue: "closeKeyboardNotif"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(habilitarTextField), name: NSNotification.Name(rawValue: "unlockTextField"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector:#selector(routeChange(_:)),name:NSNotification.Name.AVAudioSessionRouteChange, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.paintMessage(_:)), name: NSNotification.Name(rawValue: "paintMessage"), object: nil)
        

        DataUserDefaults.setPushType(type: "0")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatS1TableViewController, segue.identifier == "ChildChatSegue"{
            self.childViewController = vc
        }
    }
    
    func paintMessage(_ notification: NSNotification) {
        
        if let mensaje = notification.userInfo?["mensaje"] as? String {
            self.childViewController.pintarMensajeEnviado(mensaje: mensaje, id: self.idReceptor, audioUrl: "", loadingCell: false)
        }
    }
    
    func tryCloseKeyboard(notification:NSNotification){
        self.view.endEditing(true)
    }
    
    func habilitarTextField(notification:NSNotification){
        self.mensajeTextField.isEnabled = true
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false
            , notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = keyboardFrame.height - 40
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if show{
                self.bottomConstraint.constant += changeInHeight
                
            }else{
                self.bottomConstraint.constant = 60
            }
        })
        
    }
    
    func gotoBloquear(sender: UIButton){
        self.performSegue(withIdentifier: "gotoBloquear", sender: nil)
    }
    
    func gotoPerfilPersona(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoPerfilPersona", sender: nil)
    }
    
    func routeChange(_ notification:Notification) {
        print("routeChange \((notification as NSNotification).userInfo)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func checkHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
    func startStopRecording(sender: UITapGestureRecognizer){
        if recorder == nil {
            checkHeadphones()
            print("recording. recorder nil")
            self.infoRecord.isHidden = false
            recordWithPermission(true)
            return
        }else{
            print("stop")
            
            recorder?.stop()
            player?.stop()
            
            meterTimer.invalidate()
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
                self.infoRecord.isHidden = true
                self.infoRecord.text = "00:00"
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
            recorder = nil
            
            self.mensajeTextField.isEnabled = false
            self.childViewController.enviarMensajeMultimedia(audioUrl: self.soundFileURL, receptor: self.idReceptor)
        }
        
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if recorder.isRecording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
            let s = String(format: "%02d:%02d", min, sec)
            self.infoRecord.text = s
            recorder.updateMeters()
            // if you want to draw some graphics...
            //var apc0 = recorder.averagePowerForChannel(0)
            //var peak0 = recorder.peakPowerForChannel(0)
        }
    }
    
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target:self,
                                                           selector:#selector(self.updateAudioMeter(_:)),
                                                           userInfo:nil,
                                                           repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
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
        
        self.view.insertSubview(view, at:0)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        debugPrint("Funciona esta mierda de begin editing?")
        if textField == self.mensajeTextField {
            debugPrint("empezare a escribir!!!")
            self.childViewController.scrollToBottom()
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                debugPrint("Funciona esta mierda de should return?")
        if textField == self.mensajeTextField {
            
            if !(self.mensajeTextField.text?.isEmpty)!{
                self.mensajeTextField.isEnabled = false
                self.childViewController.enviarMensaje(mensaje: self.mensajeTextField.text!,receptor:self.idReceptor)
                self.mensajeTextField.text = ""
            }
            
            
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func close(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
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
