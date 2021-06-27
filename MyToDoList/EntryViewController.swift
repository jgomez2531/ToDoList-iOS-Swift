//
//  EntryViewController.swift
//  MyToDoList
//
//  Created by Juanma Gómez on 27/6/21.
//

import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFiled: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFiled.becomeFirstResponder()
        textFiled.delegate = self
        
        datePicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self , action: #selector(didTapSaveButton))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func didTapSaveButton() {
        if let text = textFiled.text, !text.isEmpty {
            let date = datePicker.date
            
            realm.beginWrite()
            
            let newItem = ToDoListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
             
            try! realm.commitWrite()
            
            completionHandler?()
            
            navigationController?.popToRootViewController(animated: true)
        }
        else {
             print("Añade algo")
        }
    }


}
