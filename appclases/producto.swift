//
//  producto.swift
//  appclases
//
//  Created by Daniel Torres Moreno on 9/12/19.
//  Copyright © 2019 Daniel Torres Moreno. All rights reserved.
//

import Foundation
class Producto {//CLASE PRODUCTO
    var idProducto : String
    var nomProducto : String
    var existencia : String
    
    
    
    init (idProd : String, nomProd : String , existen : String){//Hace la funcion del constructor
        self.idProducto = idProd
        self.nomProducto = nomProd
        self.existencia = existen
    
    
    }
    
}
