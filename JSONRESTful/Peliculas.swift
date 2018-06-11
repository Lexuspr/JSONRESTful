//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by MAC10 on 11/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation
struct Peliculas:Decodable {
    var usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
