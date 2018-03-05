//
//  TLSuggestionCell.swift
//  Taylor
//
//  Created by Benjamin Pisano on 05/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class TLSuggestionCell: NSView {
    @IBOutlet weak var textLabel: NSTextField!
    
    override func awakeFromNib() {
        textLabel.textColor = NSColor.black
    }
}
