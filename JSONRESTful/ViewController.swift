//
//  ViewController.swift
//  JSONRESTful
//
//  Created by MAC10 on 11/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func validarUsuario(ruta:String, completed: @escaping () ->() ) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    @IBAction func logear(_ sender: UIButton) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: crearURL) {
            if self.users.count <= 0 {
                print("Nombre de usuario y/o contraseña es incorrecta")
            } else {
                print("Logeo exitoso")
                let usuario = self.users[0]
                self.performSegue(withIdentifier: "segueLogueo", sender: usuario)
                for data in self.users{
                    print("id:\(data.id),nombre:\(data.nombre),email:\(data.email)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogueo" {
            let siguienteVC = segue.destination.childViewControllers[0] as! ViewControllerBuscar
            siguienteVC.usuario = sender as? Users
            print("Segue")
            print(segue.destination.childViewControllers[0])
            print("Fin segue")
        }
    }

}

