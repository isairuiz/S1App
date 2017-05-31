//
//  Estructuras.swift
//  S1ngular
//
//  Created by Akira Redwolf on 04/11/16.
//  Copyright © 2016 Akira Redwolf. All rights reserved.
//

import Foundation
import UIKit

struct GeneralTableItem {
    let id: Int
    let nombre:String
    let ditancia:String
    let tiempo:String
    let lugar:String
    let descripcion:String
    let avatar:String
    let badge:String
    let compartir:Bool
    let resaltar:Bool
    let restriccion:Float
    
    
    init(id:Int, nombre:String, distancia:String, tiempo:String, lugar:String, descripcion:String, avatar:String, badge:String, compartir:Bool, resaltar:Bool, restriccion:Float){
        self.id = id
        self.nombre = nombre
        self.ditancia = distancia
        self.tiempo = tiempo
        self.lugar = lugar
        self.descripcion = descripcion
        self.avatar = avatar
        self.badge = badge
        self.compartir = compartir
        self.resaltar = resaltar
        self.restriccion = restriccion
        
    }
    
    
}


struct TestItem {
    let id: Int
    let nombre:String
    let descripcion:String
    let resultado:String
    let costo:Int
    let recompensa:Int
    let imagen:String
    
    
    init(id:Int, nombre:String, descripcion:String, costo:Int, recompensa:Int, imagen:String, resultado:String = ""){
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.costo = costo
        self.recompensa = recompensa
        self.resultado = resultado
        self.imagen = imagen
        
    }
    
    
}

struct Test {
    let id: Int
    let nombre:String
    let descripcion: String
    let tag: String
    let preguntas: [TestPregunta]
    let costo:Int
    let recompensa:Int
    let imagen:String
    
    init(id:Int, nombre:String, descripcion:String, tag:String, costo:Int, recompensa:Int, imagen:String, preguntas:[TestPregunta]){
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.tag = tag
        self.costo = costo
        self.recompensa = recompensa
        self.preguntas = preguntas
        self.imagen = imagen
        
    }
}

enum TipoPregunta {
    case texto
    case imagen
}

struct TestPregunta {
    let id: Int
    let pregunta: String
    let tipo: TipoPregunta
    let tipoRespuestas: TipoRespuesta
    let imagen: String
    let respuestas: [TestRespuesta]
    
    init(id: Int, pregunta: String, tipo: TipoPregunta, imagen:String = "",  tipoRespuestas: TipoRespuesta, respuestas:[TestRespuesta]){
        self.id = id
        self.pregunta = pregunta
        self.tipo = tipo
        self.imagen = imagen
        self.tipoRespuestas = tipoRespuestas
        self.respuestas = respuestas
    }
}

enum TipoRespuesta {
    case texto
    case color
}

struct TestRespuesta {
    let id:Int
    let respuesta:String
    let color:UIColor
    
    init(id: Int, respuesta:String = "", color:UIColor = UIColor.clear){
        self.id = id
        self.respuesta = respuesta
        self.color = color
    }
}
