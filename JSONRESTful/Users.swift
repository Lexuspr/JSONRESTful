//
//  Users.swift
//  JSONRESTful
//
//  Created by MAC10 on 11/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct Users:Decodable{
    let id:Int
    let nombre:String
    let clave:String
    let email:String
}
