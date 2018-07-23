//
//  MainViewController.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var model: BlockNotesModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        actIndicator.isHidden = true
    }
    
    func toggleUI(switchOn: Bool) {
        if switchOn {
            tableView.isUserInteractionEnabled = true
            self.btnAdd.isEnabled = true
            self.btnRefresh.isEnabled = true
            self.actIndicator.isHidden = true
        } else {
            tableView.isUserInteractionEnabled = false
            self.btnAdd.isEnabled = false
            self.btnRefresh.isEnabled = false
            self.actIndicator.isHidden = false
            self.actIndicator.startAnimating()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNoteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BlockNotesTableViewCell {
            if let note = model.getNote(index: indexPath.row) {
                cell.setupCell(id: note.id, text: note.text)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "X") { (action, indexPath) in
            if let note = self.model.getNote(index: indexPath.row) {
                self.confirmDelete(id: note.id)
            }
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    func confirmDelete(id: Int) {
        let alert = UIAlertController(title: NSLocalizedString("Delete note", comment: ""), message: NSLocalizedString("Are you sure?", comment: ""), preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (Action) -> Void in
            self.toggleUI(switchOn: false)
            BlockNotesNetworking().sendDeleteRequest(id: id) { response, data in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 204 {
                        self.model.deleteNote(id: id)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.toggleUI(switchOn: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: NSLocalizedString("Network error", comment: ""), message: NSLocalizedString("Response code:", comment: "") + " \(response.statusCode)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            self.toggleUI(switchOn: true)
                        }
                    }
                }
            }
        })
        let CancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (Action) -> Void in })
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToEdit", let destination = segue.destination as? EditViewController, let row = tableView.indexPathForSelectedRow {
                if let selectedCell = tableView.cellForRow(at: row) as? BlockNotesTableViewCell {
                    destination.id = selectedCell.id
                    destination.model = model
                }
        }
    }
    
    @IBAction func btnRefreshTapped(_ sender: Any) {
        toggleUI(switchOn: false)
        BlockNotesNetworking().sendGetRequest(request: "notes") { data in
            if let data = data {
                self.model.clearNotes()
                self.model.addNote(json: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.toggleUI(switchOn: true)
                }
            }
        }
    }
   
    @IBAction func btnAddTapped(_ sender: Any) {
        toggleUI(switchOn: false)
        BlockNotesNetworking().sendPostRequest() { response, data in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                    if let data = data {
                        self.model.addNote(json: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.toggleUI(switchOn: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: NSLocalizedString("Network error", comment: ""), message: NSLocalizedString("Response code:", comment: "") + " \(response.statusCode)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        self.tableView.reloadData()
                        self.toggleUI(switchOn: true)
                    }
                }
            }
        }
    }
    
}
