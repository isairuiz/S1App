//
//  Utilierias.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import Foundation
import UIKit

class Utilerias {
    static func aplicarEfectoDifuminacionImagen(_ image: UIImage, intensidad: Float) -> UIImage {
        
        let ciContext = CIContext(options: nil)
        
        let ciImage = CIImage(image: image)
        
        let ciFilter = CIFilter(name: "CIGaussianBlur")
        
        ciFilter!.setValue(ciImage, forKey: kCIInputImageKey)
        
        ciFilter!.setValue(intensidad, forKey: "inputRadius")
        
        let cgImage = ciContext.createCGImage(ciFilter!.outputImage!, from: ciImage!.extent)
        
        return UIImage(cgImage: cgImage!)
    }
    
    static func getCurrentDateAndTime()->String{
        let date = NSDate()
        var calendar = NSCalendar.current
        let current = String(describing:calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        return current
    }
    
    
    static func setCustomLoadingScreen(loadingView:UIView,tableView:UITableView,loadingLabel:UILabel,spinner:UIActivityIndicatorView) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 140
        let height: CGFloat = 50
        let x = (UIScreen.main.bounds.width / 2) - (width / 2)
        let y = (UIScreen.main.bounds.height / 2) - (height / 2) - 100
        loadingView.frame = CGRect(x:x, y:y, width:width, height:height)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5
        loadingView.backgroundColor = Colores.BGPink
        
        // Sets loading text
        loadingLabel.textColor = Colores.BGWhite
        loadingLabel.textAlignment = NSTextAlignment.center
        loadingLabel.text = "Cargando..."
        loadingLabel.frame = CGRect(x:0+15, y:0+10, width:150, height:30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        spinner.frame = CGRect(x:0, y:0, width:50, height:50)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    static func removeCustomLoadingScreen(loadingView:UIView,loadingLabel:UILabel,spinner:UIActivityIndicatorView) {
        UIApplication.shared.endIgnoringInteractionEvents()
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        loadingView.isHidden = true

    }
    

    
}
public extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        debugPrint(url)
        downloadedFrom(url: url, contentMode: mode)
    }
}





