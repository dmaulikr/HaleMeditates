//
//  JournalsTableViewCell.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class JournalsTableViewCell: UITableViewCell {
    
    var model: JournalEntry? {
        didSet {
            entryTextLabel.text = model!.entry;
            dateTextLabel.text = model!.startDateString;
        }
    }

    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
