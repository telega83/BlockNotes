//
//  EditViewController.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    
    var model: BlockNotesModel!
    var id: Int = 0
    var initialText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.isEnabled = false
        txtNote.delegate = self
        actIndicator.isHidden = true
        
        if let note = model.getNote(id: id) {
            lblId.text = "Note \(note.id)"
            txtNote.text = note.text
            initialText = note.text
        }
    }
    
    func toggleUI(switchOn: Bool) {
        if switchOn {
            txtNote.isEditable = true
            btnBack.isEnabled = true
            btnRefresh.isEnabled = true
            actIndicator.isHidden = true
        } else {
            actIndicator.isHidden = false
            actIndicator.startAnimating()
            txtNote.isEditable = false
            btnBack.isEnabled = false
            btnSave.isEnabled = false
            btnRefresh.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editToMain", let destination = segue.destination as? MainViewController {
            destination.model = model
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if txtNote.text != initialText {
            btnSave.isEnabled = true
        } else {
            btnSave.isEnabled = false
        }
    }
    
    @IBAction func btnRefreshTapped(_ sender: Any) {
        toggleUI(switchOn: false)
        BlockNotesNetworking().sendGetRequest(request: "notes/\(id)") { data in
            if let data = data {
                self.model.updateNote(id: self.id, json: data)
                if let note = self.model.getNote(id: self.id) {
                    DispatchQueue.main.async {
                        self.txtNote.text = note.text
                        self.toggleUI(switchOn: true)
                    }
                }
            }
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        toggleUI(switchOn: false)
        BlockNotesNetworking().sendPutRequest(id: id, text: txtNote.text) { response, data in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                    if let data = data {
                        self.model.updateNote(id: self.id, json: data)
                        if let note = self.model.getNote(id: self.id) {
                            DispatchQueue.main.async {
                                self.txtNote.text = note.text
                                self.toggleUI(switchOn: true)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Network error", message: "Response code: \(response.statusCode)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        self.toggleUI(switchOn: true)
                    }
                }
            }
        }
    }
    
}
