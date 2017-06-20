//
//  TuSingleChildTableViewController.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 09/06/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import SwiftyJSON

class TuSingleChildTableViewController: UITableViewController {
    
    var jsonAfinidades : [JSON] = [JSON.null]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonAfinidades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AfinidadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "afinidadCell", for: indexPath) as! AfinidadTableViewCell
        
        let itemAfinidad = jsonAfinidades[indexPath.row]
        if let ambito = itemAfinidad["ambito"].string{
            if ambito != "Total"{
                cell.ambito.text = ambito
                let numero = itemAfinidad["porcentaje"].string
                cell.porcentaje.text = numero
            }
        }
        
        return cell
    }
    
    func setAfinidadesForTable(afinidades:[JSON]){
        debugPrint("Afinidades: \(afinidades)")
        self.jsonAfinidades = afinidades
        tableView.reloadData()
    }


}
