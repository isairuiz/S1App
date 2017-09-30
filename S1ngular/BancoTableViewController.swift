//
//  BancoTableViewController.swift
//  S1ngular
//
//  Created by Akira Redwolf on 12/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import StoreKit
import Alamofire
import SwiftyJSON

class BancoTableViewController: UITableViewController, UITextFieldDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver {

    @IBOutlet weak var item1S1Credits: BancoIAPTableViewCell!
    @IBOutlet weak var item2S1Credits: BancoIAPTableViewCell!
    @IBOutlet weak var item3S1Credits: BancoIAPTableViewCell!
    
    @IBOutlet weak var s1credits: UILabel!
    @IBOutlet weak var cuponTextField: UITextField!
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    let loadingView2 = UIView()
    let spinner2 = UIActivityIndicatorView()
    let loadingLabel2 = UILabel()
    
    var productIDs: Array<String?> = []
    var productsArray: Array<SKProduct> = []
    var selectedProductIndex: Int!
    var idPaqueteSingular: Int!
    var transactionInProgress = false
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+DataUserDefaults.getUserToken()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.item1S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item1S1Credits.layer.shadowOpacity = 0.5
        self.item1S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item1S1Credits.layer.shadowRadius = 3
        
        
        self.item2S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item2S1Credits.layer.shadowOpacity = 0.5
        self.item2S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item2S1Credits.layer.shadowRadius = 3
        
        
        self.item3S1Credits.layer.shadowColor = UIColor.black.cgColor
        self.item3S1Credits.layer.shadowOpacity = 0.5
        self.item3S1Credits.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.item3S1Credits.layer.shadowRadius = 3
        
        self.cuponTextField.delegate = self
        
        let tapViewItem1 = UITapGestureRecognizer(target: self, action: #selector(self.selectPaquete1(sender:)))
        let tapViewItem2 = UITapGestureRecognizer(target: self, action: #selector(self.selectPaquete2(sender:)))
        let tapViewItem3 = UITapGestureRecognizer(target: self, action: #selector(self.selectPaquete3(sender:)))
        
        self.item1S1Credits.addGestureRecognizer(tapViewItem1)
        self.item2S1Credits.addGestureRecognizer(tapViewItem2)
        self.item3S1Credits.addGestureRecognizer(tapViewItem3)
        
        self.cuponTextField.returnKeyType = .send
        
        self.s1credits.text = "\(DataUserDefaults.getSaldo()) S1 Credits"
        let tapView = UITapGestureRecognizer(target: self, action: #selector(self.finalizarEdicion(_:)))
        self.view.addGestureRecognizer(tapView)
        
        productIDs.append("0001")
        productIDs.append("0002")
        productIDs.append("0003")
        
        requestProductInfo()
        
        self.tableView.register(CreditsTableViewCell.self, forCellReuseIdentifier: "s1CreditsCell")
        self.tableView.register(BancoIAPTableViewCell.self, forCellReuseIdentifier: "cellProduct")
        self.tableView.register(CuponTableViewCell.self, forCellReuseIdentifier: "cuponCell")
        
        SKPaymentQueue.default().add(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startBuyTransaction), name: NSNotification.Name(rawValue: "buyConfirmedNotif"), object: nil)
        
    }
    
    
    
    func requestProductInfo() {
        showLoader()
        if SKPaymentQueue.canMakePayments() {
            
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            debugPrint("No se puede utilizar In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0{
            var counter:Int = 0
            for product in response.products{
                productsArray.append(product)
                let indexPath = IndexPath(row: counter, section: 1)
                let cellProduct:BancoIAPTableViewCell = self.tableView.cellForRow(at: indexPath) as! BancoIAPTableViewCell
                cellProduct.coinTitle.text = product.localizedTitle
                cellProduct.coinPrice.text = "$\(product.price).00 MXN"
                counter += 1
            }
            removeLoader()
        }else{
            debugPrint("No hay productos en appstore")
        }
        if response.invalidProductIdentifiers.count != 0 {
            debugPrint("Nombre de producto invalido:")
            debugPrint(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                debugPrint("Transaction complete :)")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                comprarPaqueteS1(id: self.idPaqueteSingular)
                break
            case SKPaymentTransactionState.failed:
                debugPrint("Transaction failed :(")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                removeLoader()
                break
            default:
                debugPrint(transaction.transactionState.rawValue)
                removeLoader()
            }
        }
    }
    
    func comprarPaqueteS1(id:Int){
        if Utilerias.isConnectedToNetwork(){
            let lView = UIView()
            let lLabel = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
            let parameters: Parameters = ["id_paquete": id]
            AFManager.request(Constantes.COMPRAR_PAQUETE, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if status{
                                if let saldos1 = json["saldo"].int{
                                    self.s1credits.text = "\(saldos1) S1 Credits"
                                    DataUserDefaults.setSaldo(saldo: saldos1)
                                    Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                                }
                            }else{
                                if let errorMessage = json["mensaje_plain"].string{
                                    Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                                    self.alertWithMessage(title: "¡Algo va mal!", message: errorMessage)
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            self.alertWithMessage(title: "Error", message: "El servidor esta fuera de linea, por favor intenta mas tarde.")
                            debugPrint("timeOut")
                        }else{
                            self.alertWithMessage(title:"Error",message:"El servidor encontro un error, por favor intenta mas tarde.")
                        }
                        break
                    }
            }
        }else{
            self.alertWithMessage(title: "Error", message: "No estas conectado, revisa tu conexión a internet.")
        }
        
    }
    
    func canjearCupon(cupon:String){
        if Utilerias.isConnectedToNetwork(){
            let lView = UIView()
            let lLabel = UILabel()
            let spinner = UIActivityIndicatorView()
            Utilerias.setCustomLoadingScreen(loadingView: lView, tableView: self.tableView, loadingLabel: lLabel, spinner: spinner)
            let parameters: Parameters = ["codigo": cupon]
            AFManager.request(Constantes.CANJEAR_CUPON, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: self.headers)
                .responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        debugPrint(json)
                        if let status = json["status"].bool{
                            if status{
                                if let saldo = json["saldo"].int{
                                    self.s1credits.text = "\(saldo) S1 Credits"
                                    DataUserDefaults.setSaldo(saldo: saldo)
                                    if let message = json["mensaje_plain"].string{
                                        self.alertWithMessage(title: "¡Bien!", message: message)
                                        Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                                    }
                                }
                            }else{
                                if let errorMessage = json["mensaje_plain"].string{
                                    Utilerias.removeCustomLoadingScreen(loadingView: lView, loadingLabel: lLabel, spinner: spinner)
                                    self.alertWithMessage(title: "¡Algo va mal!", message: errorMessage)
                                }
                            }
                            self.cuponTextField.text = ""
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            self.alertWithMessage(title: "Error", message: "El servidor esta fuera de linea, por favor intenta mas tarde.")
                            debugPrint("timeOut")
                        }else{
                            self.alertWithMessage(title:"Error",message:"El servidor encontro un error, por favor intenta mas tarde.")
                        }
                        break
                        
                    }
                    
            }
        }else{
            self.alertWithMessage(title: "Error", message: "No estas conectado, revisa tu conexión a internet.")
        }
        
    }
    
    func selectPaquete1(sender: UITapGestureRecognizer){
        if transactionInProgress{
            return
        }
        selectedProductIndex = 0
        idPaqueteSingular = 4
        showCustomAlert()
    }
    func selectPaquete2(sender: UITapGestureRecognizer){
        if transactionInProgress{
            return
        }
        selectedProductIndex = 1
        idPaqueteSingular = 5
        showCustomAlert()
    }
    func selectPaquete3(sender: UITapGestureRecognizer){
        if transactionInProgress{
            return
        }
        selectedProductIndex = 2
        idPaqueteSingular = 6
        showCustomAlert()
    }
    
    func startBuyTransaction(){
        showLoader()
        let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
    }
    
    
    
    func showCustomAlert(){
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CustomAlert")
        
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: viewController)
        formSheetController.presentationController?.isTransparentTouchEnabled = false
        self.present(formSheetController, animated: true, completion: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
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
        
        self.tableView.backgroundView = view
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 8.0;
        }
        
        return tableView.sectionHeaderHeight;
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 0.8
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.alpha = 1
    }
    
    func showLoader(){
        Utilerias.setCustomLoadingScreen(loadingView: self.loadingView, tableView: self.tableView, loadingLabel: self.loadingLabel, spinner: self.spinner)
        
    }
    func removeLoader(){
        Utilerias.removeCustomLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner)
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == self.cuponTextField {
            let codigo:String = self.cuponTextField.text!
            if !codigo.isEmpty{
                self.canjearCupon(cupon: codigo)
            }else{
                debugPrint("no hay codigo")
            }
        }
        
        return true
    }
    
    // MARK: - Eventos
    
    func finalizarEdicion(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // MARK: -Actions
    
    @IBAction func regresar(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
