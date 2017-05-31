//
//  HacerCheckInTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 20/12/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HacerCheckInTableViewController: UITableViewController,  CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var starsContentView: UIView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var hacerCheckInTableViewCell: UITableViewCell!
    @IBOutlet weak var compartirCheckInTableViewCell: UITableViewCell!
    
    @IBOutlet weak var hacerCheckInViewButton: UIView!
    @IBOutlet weak var compartirCheckInViewButton: UIView!
    
    
    @IBOutlet weak var mapTableViewCell: UITableViewCell!
    @IBOutlet weak var dondeEstasTableViewCell: UITableViewCell!
    @IBOutlet weak var queHacesTableViewCell: UITableViewCell!
    
    @IBOutlet weak var dondeEstasTextField: UITextField!
    @IBOutlet weak var queHacesTextField: UITextField!
    
    
    var calificacion:Int = 0
    var checkInRealizado:Bool = false
    
    var locationManager:CLLocationManager = CLLocationManager();
    var ubicacion: CLLocationCoordinate2D!;
    var ubicacionCentrada = false

    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.starsContentView.layoutIfNeeded()
        self.starsContentView.layer.cornerRadius = self.starsContentView.bounds.height / 2
        
        
        let hacerCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.hacerCheckIn))
        self.hacerCheckInTableViewCell.addGestureRecognizer(hacerCheckInTap)
        
        let compartirCheckInTap = UITapGestureRecognizer(target: self, action: #selector(self.compartirCheckIn))
        self.compartirCheckInTableViewCell.addGestureRecognizer(compartirCheckInTap)
        
        self.hacerCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.hacerCheckInViewButton.layer.shadowOpacity = 0.5
        self.hacerCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.hacerCheckInViewButton.layer.shadowRadius = 3
        
        self.compartirCheckInViewButton.layer.shadowColor = UIColor.black.cgColor
        self.compartirCheckInViewButton.layer.shadowOpacity = 0.5
        self.compartirCheckInViewButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.compartirCheckInViewButton.layer.shadowRadius = 3
        
        self.mapa.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        ubicacion = nil
        locationManager.startUpdatingLocation()
        
        
        self.dondeEstasTextField.delegate = self
        self.queHacesTextField.delegate = self
        
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
    }

    // MARK: - Eventos y acciones
    
    @IBAction func star1Presionada(_ sender: AnyObject) {
        
        self.calificacion = 1
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star2Presionada(_ sender: AnyObject) {
        
        self.calificacion = 2
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star3Presionada(_ sender: AnyObject) {
        
        self.calificacion = 3
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star4Presionada(_ sender: AnyObject) {
        
        self.calificacion = 4
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "Star"), for: UIControlState.normal)
        
    }
    @IBAction func star5Presionada(_ sender: AnyObject) {
        
        self.calificacion = 5
        self.star1.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star2.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star3.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star4.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        self.star5.setImage(UIImage(named: "StarFilled"), for: UIControlState.normal)
        
    }
    
    func hacerCheckIn(){
        self.checkInRealizado = true
        
        self.mapTableViewCell.isUserInteractionEnabled = false
        self.dondeEstasTableViewCell.isUserInteractionEnabled = false
        self.queHacesTableViewCell.isUserInteractionEnabled = false
        
        self.tableView.reloadData()
        
    }
    func compartirCheckIn(){
        
        print("compartir")
        
    }
    
    // MARK: -  Table
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 3 || indexPath.row == 4 {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        // Logo
        if indexPath.row == 0 {
            return 200
        }
        // Slogan y delimitador "o"
        if indexPath.row == 1 || indexPath.row == 2 {
            return 66
        }
        
        if !self.checkInRealizado && indexPath.row == 3 {
            return 78
        }
        
        if self.checkInRealizado && indexPath.row == 4 {
            return 78
        }
        
        return 0
        
    }

   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        /*
        UIView.animateWithDuration(0.2, animations: {
            self.pasajeroLocationIcon.center.y += 10.0
            
            
            let sombraWidth = self.sombraPasajeroLocationIcon.frame.size.width
            let sombraHeight = self.sombraPasajeroLocationIcon.frame.size.height
            
            
            self.sombraPasajeroLocationIcon.frame.size.width = sombraWidth / 1.2
            self.sombraPasajeroLocationIcon.frame.size.height = sombraHeight / 1.2
            
            self.sombraPasajeroLocationIcon.center.x += (sombraWidth - self.sombraPasajeroLocationIcon.frame.size.width ) / 2
            self.sombraPasajeroLocationIcon.center.y += (sombraHeight - self.sombraPasajeroLocationIcon.frame.size.height) / 2
            
            
            
        }, completion: nil)*/
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        /*
        UIView.animateWithDuration(0.3, animations: {
            self.pasajeroLocationIcon.center.y -= 10.0
            
            let sombraWidth = self.sombraPasajeroLocationIcon.frame.size.width
            let sombraHeight = self.sombraPasajeroLocationIcon.frame.size.height
            
            
            
            self.sombraPasajeroLocationIcon.frame.size.width *= 1.2
            self.sombraPasajeroLocationIcon.frame.size.height *= 1.2
            
            self.sombraPasajeroLocationIcon.center.x -= (self.sombraPasajeroLocationIcon.frame.size.width - sombraWidth) / 2
            self.sombraPasajeroLocationIcon.center.y -= (self.sombraPasajeroLocationIcon.frame.size.height - sombraHeight) / 2
            
            
            
        }, completion: nil)*/
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        self.ubicacion = manager.location!.coordinate
        
        //let location = locations.last! as CLLocation
        
        
        
        if !ubicacionCentrada {
            let center = CLLocationCoordinate2D(latitude: self.ubicacion.latitude, longitude: self.ubicacion.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            
            self.mapa.setRegion(region, animated: true)
            ubicacionCentrada = true
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        let alert = UIAlertController(title: "Error", message: "No se pudo cargar tu ubicación", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.cancel, handler:nil)
        alert.addAction(okAction)
        self.ubicacion = nil;
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.dondeEstasTextField {
            self.queHacesTextField.becomeFirstResponder()
        }
        
        if textField == self.queHacesTextField {
            
            self.view.endEditing(true)
            
        }
        
        return true
    }
    
    // MARK: - Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }



}
