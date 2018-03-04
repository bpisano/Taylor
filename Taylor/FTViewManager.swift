//
//  FTViewManager.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class FTViewManager: NSObject {
    
    func projectView(user: FTUser, parameters: [String: Any?]?) -> NSView? {
        guard let projectView = view(named: "FTProjectView") as? FTProjectView else {
            return nil
        }
        
        let keywords = FTKeyword.getKeywords(parameters: parameters, exclude: ["User"])
        
        guard let projectName = keywords.keyword(key: "Project")?.value else {
            return nil
        }
        
        projectView.configure(user: user, projectName: projectName)
        return projectView
    }
    
    func profilView(user: FTUser) -> NSView? {
        guard let profilView = view(named: "FTProfilView") as? FTProfilView else {
            return nil
        }
        
        profilView.configure(user: user)
        return profilView
    }
    
    func logView(user: FTUser) -> NSView? {
        guard let logView = view(named: "FTLogView") as? FTLogView else {
            return nil
        }
        
        logView.configure(user: user)
        return logView
    }
    
    func exampleView() -> NSView? {
        guard let exampleView = view(named: "FTExampleView") as? FTExampleView else {
            return nil
        }
        
        return exampleView
    }
    
    private func view(named name: String) -> NSView? {
        var topLevelObjects: NSArray?
        guard Bundle.main.loadNibNamed(NSNib.Name(name), owner: self, topLevelObjects: &topLevelObjects) else {
            return nil
        }
        
        return topLevelObjects!.first(where: { $0 is NSView }) as? NSView
    }
}
