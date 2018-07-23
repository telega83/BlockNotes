//
//  StartViewController.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    var model: BlockNotesModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actIndicator.startAnimating()
        BlockNotesNetworking().sendGetRequest(request: "notes") { data in
            if let data = data {
                self.model.addNote(json: data)
                DispatchQueue.main.async {
                    self.actIndicator.isHidden = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.performSegue(withIdentifier: "startToMain", sender: self)
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startToMain", let destination = segue.destination as? MainViewController {
            destination.model = model
        }
    }
    
}
