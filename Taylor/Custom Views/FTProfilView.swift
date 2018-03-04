//
//  FTProfilView.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTProfilView: NSView {
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var staffLabel: NSTextField!
    @IBOutlet weak var logIndicator: FTLogIndicator!
    @IBOutlet weak var levelLabel: NSTextField!
    @IBOutlet weak var levelIndicator: NSProgressIndicator!
    @IBOutlet weak var correctionPointLabel: NSTextField!
    @IBOutlet weak var walletLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    
    override func awakeFromNib() {
        staffLabel.wantsLayer = true
        staffLabel.layer?.cornerRadius = 2
        staffLabel.layer?.masksToBounds = true
    }
    
    func configure(user: FTUser) {
        nameLabel.stringValue = "\(user.firstName) \(user.lastName)"
        usernameLabel.stringValue = user.username
        emailLabel.stringValue = user.email
        levelLabel.stringValue = "Level \(user.level)"
        levelIndicator.doubleValue = user.levelProgress * 1000
        correctionPointLabel.stringValue = "\(user.correctionPoints)"
        walletLabel.stringValue = "\(user.wallet)"
        logIndicator.set(state: user.location == nil ? .unavailable : .available)
        locationLabel.stringValue = user.location == nil ? "Unavailable" : "\(user.location!)"
        staffLabel.isHidden = !user.isStaff
    }
}
