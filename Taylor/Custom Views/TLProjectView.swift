//
//  TLProjectView.swift
//  Taylor
//
//  Created by Benjamin Pisano on 04/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class TLProjectView: NSView {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var markLabel: NSTextField!
    
    override func awakeFromNib() {
        statusLabel.wantsLayer = true
        statusLabel.layer?.cornerRadius = 2
        statusLabel.layer?.masksToBounds = true
        statusLabel.textColor = NSColor.white
    }
    
    func configure(user: FTUser, projectName: String) {
        nameLabel.stringValue = projectName
        usernameLabel.stringValue = user.username
        
        guard let project = user.project(name: projectName) else {
            markLabel.isHidden = true
            statusLabel.stringValue = "not registered"
            return
        }
        
        statusLabel.stringValue = status(user: user, project: project)
        if project.status != .finished {
            markLabel.isHidden = true
        }
        else {
            markLabel.stringValue = "\(project.mark)"
            if project.mark < 75 {
                statusLabel.backgroundColor = NSColor.red
            }
            else {
                statusLabel.backgroundColor = NSColor.green
            }
        }
    }
    
    private func status(user: FTUser, project proj: FTProject) -> String {
        guard let project = user.project(name: proj.name) else {
            return "not started"
        }
        
        if project.status == .inProgress {
            return "in progress"
        }
        return "finished"
    }
}
