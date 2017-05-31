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





