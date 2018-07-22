//
//  BlockNotesTableViewCell.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class BlockNotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    private var _id: Int = 0
    
    var id: Int {
        get {
            return _id
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(id: Int, text: String) {
        _id = id
        lblId.text = "\(id)"
        lblText.text = text
    }
}
