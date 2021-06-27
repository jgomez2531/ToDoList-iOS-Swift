//
//  ViewController.swift
//  MyToDoList
//
//  Created by Juanma Gómez on 27/6/21.
//

import RealmSwift
import UIKit

class ToDoListItem:Object {
    @objc dynamic var item:String = ""
    @objc dynamic var date:Date = Date()
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet var table:UITableView!
    private let realm = try! Realm()
    private var data = [ToDoListItem]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        table.delegate = self
        table.dataSource = self
    }
    
    //TABLA
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Abrir la pantalla cuando podamos ver la informarción del item y poder eliminarlo
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
                return
        }
        
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as?  EntryViewController else {
            return
        }
        
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        
        vc.title = "Nuevo elemento"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //Obtener todos los datos de la BD y refrescar la tabla
    func refresh() {
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.reloadData()
    }


}

