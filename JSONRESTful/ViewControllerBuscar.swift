//
//  ViewControllerBuscar.swift
//  JSONRESTful
//
//  Created by MAC10 on 11/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class ViewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var peliculas = [Peliculas]()
    var usuario:Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isEditing = true
        
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero) -- Duracion:\(peliculas[indexPath.row].duracion) -- Usuario:\(peliculas[indexPath.row].usuarioId)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)  {
        
        if editingStyle == .delete {
            let pelicula_id = peliculas[indexPath.row].id
            let ruta1 = "http://localhost:3000/peliculas/\(pelicula_id)"
            denleThis(ruta: ruta1)
            let ruta = "http://localhost:3000/peliculas/"
            cargarPeliculas(ruta: ruta) {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func btnBuscar(_ sender: UIButton) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty {
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta){
                self.tableView.reloadData()
            }
        } else {
            cargarPeliculas(ruta: crearURL) {
                if self.peliculas.count <= 0 {
                    self.mostrarAlerta(title: "Error", message: "No se encontraron coincidencias para: \(nombre)", action: "cancel")
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    @IBAction func btnSalir(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNuevo(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueAgregar", sender: usuario)
    }
    func mostrarAlerta(title: String, message: String, action: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertaGuia.addAction(cancelok)
        present(alertaGuia, animated: true, completion: nil)
    }
    
    func denleThis(ruta:String) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {(data,response,error) in
            if (error != nil) {
                    print("Respuesta +++++++++++++")
                    print(response)
                } else {
                    print("Error +++++++++++++++++")
                    print(error)
                }
        })
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditar"{
            let siguienteVC = segue.destination as! ViewControllerAgregar
            siguienteVC.pelicula = sender as? Peliculas
        } else if segue.identifier == "segueAgregar" {
            let siguienteVC = segue.destination as! ViewControllerAgregar
            siguienteVC.usuario = sender as? Users
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tableView.reloadData()
        }
    }

}
