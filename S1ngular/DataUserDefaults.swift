//
//  DataUserDefaults.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 28/04/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import Foundation

class DataUserDefaults{
    
    private static let defaults = UserDefaults.standard
    
    private static var keys : [String] = [
        "isLogged",       // Index 0
        "currentEmail",   //Index 1
        "currentUser",    //Index 2
        "currentPassword", //Index 3
        "isConfirmedCoinsBuy", //Index 4
        "coinPackage",   //Index 5
        "successCoinsBuy", //Index 6
        "authToken", //Index 7
        "currentId", //Index 8
        "datausuario", //index 9
        "dataedad",//Index 10
        "datagenero",//Index 11
        "datafumo",//Index 12
        "databuscogenero",//Index 13
        "databuscofumador",//Index 14
        "databuscoedadminima",//Index 15
        "databuscoedadmaxima",//Index 16
        "databuscodistancia",//Index 17
        "databuscoamistad",//Index 18
        "databuscocortoplazo",//Index 19
        "databuscolargoplazo",//Index 20
        "databuscosalir",//Index 21
        "datafoto",//Index 22
        "dataprofesion",//Index 23
        "datasobreti",//Index 24
        "FBimageUrl",//Index 25
        "FBemail",//Index 26
        "FBId",//Index 27
        "estado",//Index 28
        "buscoSoltero", //29
        "buscoCasado",  //30
        "buscoDivorciado",//31
        "buscoSeparado",//32
        "buscoUnion",//33
        "buscoViudo",//34
        "idVerPerfil",//35
        "saldo",//Index 36
        "idFotoPerfil",//Index 37
        "urlFotoPerfil",//Index 38
        "idPaqueteMonedas",//Index 39
        "fromTabS1Nuevos", //Index 40
        "fromTabTestRes"   //INDEX 41
    ]
    static func setDefaultData(){
        for i in 13 ..< 21{
            defaults.set(0, forKey: keys[i])
        }
        for i in 29 ..< 34{
            defaults.set(0, forKey: keys[i])
        }
        for i in 10 ..< 12{
            defaults.set(0, forKey: keys[i])
        }
        defaults.set("", forKey: keys[9])
        defaults.set(0, forKey: keys[36])
        defaults.set(0, forKey: keys[37])
        defaults.set("", forKey: keys[23])
        defaults.set("", forKey: keys[24])
        defaults.set(false, forKey: keys[40])
        defaults.set(false, forKey: keys[41])
    }
    /*******************TEMP DATA*******************/
    static func saveDataFoto(foto:Data){
        defaults.set(foto, forKey: keys[22])
        debugPrint("Se ha actualizado la foto...")
        debugPrint(foto)
    }
    static func getDataFoto() -> Data{
        return defaults.data(forKey: keys[22])!
    }
    
    static func saveDataNombre(nombre:String){
        defaults.set(nombre, forKey: keys[9])
    }
    static func getDataNombre()->String{
        return defaults.string(forKey: keys[9])!
    }
    static func saveDataEdad(edad:String){
        defaults.set(edad, forKey: keys[10])
        debugPrint("edad:")
        debugPrint(edad)
    }
    static func getDataEdad()->String{
        return defaults.string(forKey: keys[10])!
    }
    
    /*0 hombre, 1 mujer*/
    static func saveDataGenero(genero:Int){
        defaults.set(genero, forKey: keys[11])
        debugPrint("genero:")
        debugPrint(genero)
    }
    static func getDataGenero()->Int{
        return defaults.integer(forKey: keys[11])
    }
    /*false no, true si*/
    static func saveDataFumo(fumo:Bool){
        defaults.set(fumo, forKey: keys[12])
        debugPrint("fumo:")
        debugPrint(fumo)
    }
    static func getDataFumo()->Bool{
        return defaults.bool(forKey: keys[12])
    }
    /*0 ninguno, 1 hombres, 2 mujeres, 3 ambos*/
    static func saveDataBuscoGenero(buscoGenero:Int){
        defaults.set(buscoGenero, forKey: keys[13])
        debugPrint("busco genero:")
        debugPrint(buscoGenero)
    }
    static func getDataBuscoGenero()->Int{
        return defaults.integer(forKey: keys[13])
    }
    /*1 si, 0 no*/
    static func saveDataBuscoFuma(buscoFuma:Int){
        defaults.set(buscoFuma, forKey: keys[14])
        debugPrint("busco fuma:")
        debugPrint(buscoFuma)
    }
    static func getDataBuscoFuma()->Int{
        return defaults.integer(forKey: keys[14])
    }
    /*edadM minima*/
    static func saveDataBuscoEdadMinima(edad:Int){
        defaults.set(edad, forKey: keys[15])
        debugPrint("busco edad min:")
        debugPrint(edad)
    }
    static func getDataBuscoEdadMinima()->Int{
        return defaults.integer(forKey: keys[15])
        
    }
    /*edad maxima*/
    static func saveDataBuscoEdadMaxima(edad:Int){
        defaults.set(edad, forKey: keys[16])
        debugPrint("busco edad max:")
        debugPrint(edad)
    }
    static func getDataBuscoEdadMaxima()->Int{
        return defaults.integer(forKey: keys[16])
    }
    /*distancia*/
    static func saveDataBuscoDistancia(distancia:Int){
        defaults.set(distancia, forKey: keys[17])
        debugPrint("busco distancia:")
        debugPrint(distancia)
    }
    static func getDataBuscoDistancia()->Int{
        return defaults.integer(forKey: keys[17])
    }
    
    
    /*0 no, 1 si*/
    static func saveDataBuscoAmistad(relacion:Int){
        defaults.set(relacion, forKey: keys[18])
    }
    static func getDataBuscoAmistadl()->Int{
        return defaults.integer(forKey: keys[18])
    }
    /*0 no, 1 si*/
    static func saveDataBuscoCortoPlazo(relacion:Int){
        defaults.set(relacion, forKey: keys[19])
    }
    static func getDataBuscoCortoPlazol()->Int{
        return defaults.integer(forKey: keys[19])
    }
    /*0 no, 1 si*/
    static func saveDataBuscoLargoPlazo(relacion:Int){
        defaults.set(relacion, forKey: keys[20])
        
    }
    static func getDataBuscoLargoPlazo()->Int{
        return defaults.integer(forKey: keys[20])
    }
    /*0 no, 1 si*/
    static func saveDataBuscoSalir(relacion:Int){
        defaults.set(relacion, forKey: keys[21])
    }
    static func getDataBuscoSalir()->Int{
        return defaults.integer(forKey: keys[21])
    }
    
    
    static func saveDataEstado(estado:Int){
        defaults.set(estado, forKey: keys[28])
    }
    /*profesion*/
    static func saveDataProfesion(profesion:String){
        defaults.set(profesion, forKey: keys[23])
    }
    static func getDataProfesion()->String{
        return defaults.string(forKey: keys[23])!
    }
    /*sobre Mi*/
    static func saveDataSobreMi(sobreti:String){
        defaults.set(sobreti, forKey: keys[24])
    }
    static func getDataSobreMi()->String{
        return defaults.string(forKey: keys[24])!
    }
    static func getDataEstado()->Int{
        return defaults.integer(forKey: keys[28])
    }
    /*busco soltero*/
    static func saveBuscoSoltero(num:Int){
        defaults.set(num, forKey: keys[29])
    }
    static func getBuscoSoltero()->Int{
        return defaults.integer(forKey: keys[29])
    }
    /*busco casado*/
    static func saveBuscoCasado(num:Int){
        defaults.set(num, forKey: keys[30])
    }
    static func getBuscoCasado()->Int{
        return defaults.integer(forKey: keys[30])
    }
    /*busco divorciado*/
    static func saveBuscoDivorciado(num:Int){
        defaults.set(num, forKey: keys[31])
    }
    static func getBuscoDivorciado()->Int{
        return defaults.integer(forKey: keys[31])
    }
    /*busco separado*/
    static func saveBuscoSeparado(num:Int){
        defaults.set(num, forKey: keys[32])
    }
    static func getBuscoSeparado()->Int{
        return defaults.integer(forKey: keys[32])
    }
    /*busco union libre*/
    static func saveBuscoUnionlibre(num:Int){
        defaults.set(num, forKey: keys[33])
    }
    static func getBuscoUnionlibre()->Int{
        return defaults.integer(forKey: keys[33])
    }
    /*busco soltero*/
    static func saveBuscoViudo(num:Int){
        defaults.set(num, forKey: keys[34])
    }
    static func getBuscoViudo()->Int{
        return defaults.integer(forKey: keys[34])
    }
    static func clearData()->Bool{
        for i in 0 ..< keys.count{
            defaults.removeObject(forKey: keys[i])
        }
        return true
    }
    /*******************TEMP DATA*******************/
    
    
    /*******************FB DATA*********************/
    static func setFBUrlImage(url:String){
        defaults.set(url, forKey: keys[25])
    }
    static func getFBUrlImage()->String{
        return defaults.string(forKey: keys[25])!
    }
    static func setFBEmail(email:String){
        defaults.set(email, forKey: keys[26])
    }
    static func getFBEmail()->String{
        return defaults.string(forKey: keys[26])!
    }
    static func setFBId(fbid:String){
        defaults.set(fbid, forKey: keys[27])
    }
    static func getFBId()->String{
        return defaults.string(forKey: keys[27])!
    }
    /*******************FB DATA*********************/
    
    /*******************Singulares DATA*********************/
    static func setIdVerPerfil(id:Int){
        debugPrint("Id perfil:")
        debugPrint(id)
        defaults.set(id, forKey: keys[35])
    }
    static func getIdVerPerfil()->Int{
        return defaults.integer(forKey: keys[35])
    }
    
    static func setSaldo(saldo:Int){
        defaults.set(saldo, forKey: keys[36])
    }
    static func getSaldo()->Int{
        return defaults.integer(forKey: keys[36])
    }
    
    static func saveIdFotoPerfil(id:Int){
        defaults.set(id, forKey: keys[37])
    }
    
    static func getidFotoPerfil()->Int{
        return defaults.integer(forKey: keys[37])
    }
    
    static func setFotoPerfilUrl(url:String){
        defaults.set(url, forKey: keys[38])
    }
    static func getFotoPerfilUrl()->String{
        return defaults.string(forKey: keys[38])!
    }
    /*******************END Singulares DATA*********************/
    
    static func setIsLogged(logged : Bool){
        defaults.set(logged, forKey: keys[0])
    }
    static func isLoggedIn() -> Bool{
        return defaults.bool(forKey: keys[0])
    }
    static func setUserData(email:String,user:String,password:String){
        defaults.set(email, forKey: keys[1])
        defaults.set(user, forKey: keys[2])
        defaults.set(password, forKey: keys[3])
    }
    static func getCurrentEmail()->String{
        return defaults.string(forKey: keys[1])!
    }
    static func getCurrentPassword()->String{
        return defaults.string(forKey: keys[3])!
    }
    static func setConfirmedCoinsBuy(flag : Bool){
        defaults.set(flag, forKey: keys[4])
    }
    static func isConfirmedCoinsBuy()->Bool{
        return defaults.bool(forKey: keys[4])
    }
    static func setCoinPackage(package : Int){
        defaults.set(package, forKey: keys[5])
    }
    static func getCointPackage()->Int{
        return defaults.integer(forKey: keys[5])
    }
    static func setSuccessCoinsBuy(flag : Bool){
        defaults.set(flag, forKey: keys[6])
    }
    static func isSuccessCoinsBuy()->Bool{
        return defaults.bool(forKey: keys[6])
    }
    static func setUserToken(token:String){
        defaults.set(token, forKey: keys[7])
    }
    static func getUserToken()->String{
        return defaults.string(forKey: keys[7])!
    }
    static func setCurrentId(id:Int){
        defaults.set(id, forKey: keys[8])
    }
    static func getCurrentId()->Int{
        return defaults.integer(forKey: keys[8])
    }
    
    static func setCurrentIdProcut(id:Int){
        defaults.set(id, forKey: keys[39])
    }
    
    static func getCurrentIdProduct()->Int{
        return defaults.integer(forKey: keys[39])
    }
    
    static func setFromTabS1Nuevos(isit:Bool){
        defaults.set(isit, forKey: keys[40])
    }
    static func getFromTabS1Nuevos()->Bool{
        return defaults.bool(forKey: keys[40])
    }
    static func setFromTabTestResult(isit:Bool){
        defaults.set(isit, forKey: keys[41])
    }
    static func getFromTabTestResult()->Bool{
        return defaults.bool(forKey: keys[41])
    }
}
