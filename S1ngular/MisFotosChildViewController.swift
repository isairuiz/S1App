//
//  MisFotosChildViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 11/05/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit

class MisFotosChildViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var listaFotos:[String] = []
    let reuseIdentifier = "fotoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        listaFotos = [
            "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg",
            "https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1",
            "http://i.dailymail.co.uk/i/pix/2015/05/29/02/2929496B00000578-3101635-image-a-1_1432862935225.jpg",
            "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg",
            "https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1",
            "http://i.dailymail.co.uk/i/pix/2015/05/29/02/2929496B00000578-3101635-image-a-1_1432862935225.jpg",
            "http://2.bp.blogspot.com/-lnt7x6S-QDE/VXB4iM3jktI/AAAAAAAAEZc/Evr1d3aQJ5M/s1600/kiss.jpg",
            "https://pmchollywoodlife.files.wordpress.com/2016/09/zodiac-signs-changed-ftr.jpg?w=600&h=400&crop=1",
            "http://i.dailymail.co.uk/i/pix/2015/05/29/02/2929496B00000578-3101635-image-a-1_1432862935225.jpg"
        ]
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listaFotos.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FotosCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.foto.downloadedFrom(link: self.listaFotos[indexPath.item])
        
        return cell
    }

}


