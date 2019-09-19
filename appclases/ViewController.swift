//
//  ViewController.swift
//  appclases
//
//  Created by Daniel Torres Moreno on 9/12/19.
//  Copyright © 2019 Daniel Torres Moreno. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    var productos = [Producto]()
    var db : OpaquePointer?
    
    @IBOutlet weak var txtClave: UITextField!
    
    @IBOutlet weak var txtNom: UITextField!
    
    @IBOutlet weak var txtExiste: UITextField!
    
    @IBAction func btnAgregar(_ sender: UIButton) {
        let clave =
        txtClave.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let nom =
        txtNom.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let existe =
        txtExiste.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       // if (clave?.isEmpty)! {
       //     showAlerta(titulo: "Advertencia", mensaje: "La caja CLAVE esta vacia")
       //     txtClave.becomeFirstResponder()
       //     return
       // }
        if (nom?.isEmpty)! {
            showAlerta(titulo: "Advertencia", mensaje: "La caja NOMBRE esta vacia")
            txtNom.becomeFirstResponder()
            return
        }
        if (existe?.isEmpty)! {
            showAlerta(titulo: "Advertencia", mensaje: "La caja EXISTE esta vacia")
            txtExiste.becomeFirstResponder()
            return
        }
        let nombr: NSString = nom! as NSString
        let existen : NSInteger = NSInteger(existe!)!
        var stmt : OpaquePointer?
        let sentencia = "INSERT INTO Producto(nomProducto, existencia) values (?,?)"
        if sqlite3_prepare(db, sentencia, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_text(stmt, 1, nombr.utf8String, -1, nil)
            sqlite3_bind_int(stmt, 2, Int32(existen))
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            showAlerta(titulo: "Error al Insertar", mensaje: errmsg)
            return
        }
        
        
        //productos.append(Producto(idProd: clave!, nomProd: nom!, existen: existe!))
        txtExiste.text = "0"
        txtNom.text = ""
        txtClave.text = ""
        txtClave.becomeFirstResponder()
        
        
    }
    @IBAction func btnConsultar(_ sender: UIButton) {
        productos.removeAll()
        let query = "SELECT idProducto , nomProducto, existencia from Producto ORDER BY nomProducto"
        var stmt : OpaquePointer?
        if(sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK){
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            showAlerta(titulo: "Error al Consultar", mensaje: errmsg)
            return
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let idp = String(sqlite3_column_int(stmt,0))
            let nom = String(cString : sqlite3_column_text(stmt,1))
            let exi = String(sqlite3_column_int(stmt,2))
            productos.append(Producto(idProd: idp,nomProd:nom,existen: exi))
        }
        let prod = productos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory , in: .userDomainMask , appropriateFor: nil , create: false) .appendingPathComponent("ProductosDatabase.sqlite")
        if sqlite3_open(fileURL.path , &db) != SQLITE_OK{
            showAlerta(titulo: "BASE DE DATOS", mensaje: "ERROR ALL ABRIR BASE DE DATOS")
        }
        if sqlite3_exec(db,"CREATE TABLE IF NOT EXISTS Producto(idProducto INTEGER PRIMARY KEY AUTOINCREMENT, nomProducto TEXT, existencia INTEGER)",nil,nil, nil) != SQLITE_OK{
            let errmsg = String(cString:sqlite3_errmsg(db)!)
            showAlerta(titulo: "Error al Crear Tabla", mensaje: errmsg)
        }
    }
    func showAlerta(titulo: String, mensaje: String){
        //Crea La Alerta
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        //Agregar Un Boton
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        //Muestra El Alerta
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "push" ){
            let tableSegue = segue.destination as! TableViewController
            tableSegue.productos = productos
        }
    }

}
