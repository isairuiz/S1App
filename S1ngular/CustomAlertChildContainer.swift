//
//  CustomAlertChildContainer.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit



class CustomAlertChildContainer: UIViewController {

    
    @IBOutlet weak var infoTextAlert: UILabel!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        
    }
    

}
