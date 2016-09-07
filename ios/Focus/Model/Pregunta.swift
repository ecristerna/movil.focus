//
//  Pregunta.swift
//  Focus
//
//  Created by Eduardo Cristerna on 27/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

enum TipoPregunta: Int {
    case Abierta = 1
    case Unica = 2
    case Multiple = 3
    case Ordenamiento = 4
}

class Pregunta {
    
    var id: Int
    var tipo: Int
    var numPregunta: Int
    var pregunta: String
    var video: String
    var imagen: String
    var opciones: [String]
    var selectedOptions: [Bool] = [false, false, false, false, false, false, false, false, false, false]
    var respuesta: String = ""
    
    init(id: Int, tipo: Int, numPregunta: Int, pregunta: String, video: String, imagen: String, opciones: [String]) {
        self.id = id
        self.tipo = tipo
        self.numPregunta = numPregunta
        self.pregunta = pregunta
        self.video = video
        self.imagen = imagen
        self.opciones = opciones
    }
    
}