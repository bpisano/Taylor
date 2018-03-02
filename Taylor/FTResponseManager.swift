//
//  FTResponseTemplate.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

class FTResponseManager: NSObject {
    
    func response(intentName: String, parameters: [String: Any?]?) -> FTResponse? {
        switch intentName {
        case "Log":
            guard let parameters = parameters else {
                return nil
            }
            
            let username = parameters["username"] as! String
            let location = parameters["location"] as! String?
            return FTResponse(response: logResponse(username: username, location: location),
                              view: FTViewManager().logView(username: username, location: location))
        case "Profil":
            guard let parameters = parameters else {
                return nil
            }
            
            let user = parameters["user"] as! FTUser
            let params = parameters["parameters"] as? [String: Any]
            return FTResponse(response: profilResponse(user: user, parameters: params),
                              view: FTViewManager().profilView(user: user))
        case "Project":
            guard let parameters = parameters else {
                return nil
            }
            
            let user = parameters["user"] as! FTUser
            let params = parameters["parameters"] as? [String: Any]
            return FTResponse(response: profilResponse(user: user, parameters: params),
                              view: FTViewManager().profilView(user: user))
        default:
            return nil
        }
    }
    
    private func projectResponse (user: FTUser, parameters: [String: Any?]?) -> String? {
        guard let projectName = parameters!["Project"] as? String else {
            return "It seems that \(user.username) does not have started this project"
        }
        
        guard let project = user.project(name: projectName) else {
            return "It seems that \(user.username) does not have started this project"
        }
        
        var keywrd: String?
        var keywrdValue: String?
        for parameter in parameters! {
            let value = (parameter.value as? AIResponseParameter)?.stringValue
            if parameter.key != "User" && parameter.key != "Profil" && value != "" {
                keywrd = parameter.key
                keywrdValue = value
                break
            }
        }
        
        guard let keyword = keywrd, let keywordValue = keywrdValue else {
            let profilTemplates = [
                "Here is the profil of \(user.username).",
                "Here it is. That's \(user.username) !",
                "\(user.username)... Okay here it is. Big applause.",
            ]
            let random = arc4random() % UInt32(profilTemplates.count)
            return profilTemplates[Int(random)]
        }
        
        switch keyword {
        case "ProjectStatus":
            if keywordValue == "start" {
                if project.status == .inProgress {
                    return "It seems that \(user.username) started \(project.displayName)."
                }
                return "Look, \(user.username) already finished \(project.displayName). It seems to be a fast guy..."
            }
            else {
                if project.status == .inProgress {
                    return "\(user.username) does not have finished \(project.displayName)."
                }
                return "\(user.username) have finished \(project.displayName)."
            }
        case "ProjectMark":
            if project.status == .inProgress {
                return "\(user.username) does not have mark on \(project.displayName) because the project is not finished yet."
            }
            return "Here it is. \(user.username) get a mark of \(project.mark)/100 on \(project.displayName)."
        default:
            return "Here is the \(project.displayName) of \(user.username)."
        }
    }
    
    private func profilResponse(user: FTUser, parameters: [String: Any?]?) -> String? {
        var keywrd: String?
        var keywrdValue: String?
        
        for parameter in parameters! {
            let value = (parameter.value as? AIResponseParameter)?.stringValue
            if parameter.key != "User" && parameter.key != "Profil" && value != "" {
                keywrd = parameter.key
                keywrdValue = value
                break
            }
        }
        
        guard let keyword = keywrd, let keywordValue = keywrdValue else {
            let profilTemplates = [
                "Here is the profil of \(user.username).",
                "Here it is. That's \(user.username) !",
                "\(user.username)... Okay here it is. Big applause.",
            ]
            let random = arc4random() % UInt32(profilTemplates.count)
            return profilTemplates[Int(random)]
        }
        
        switch keyword {
        case "Level":
            let levelTemplates = [
                "Here is the \(keywordValue) of \(user.username).",
                "\(user.username) is actually at level \(user.level).",
                "\(user.username) is at level \(user.level). Can be better...",
            ]
            let random = arc4random() % UInt32(levelTemplates.count)
            return levelTemplates[Int(random)]
        case "Wallet":
            let walletTemplates = [
                "\(user.username) have actually \(user.wallet) wallets.",
                "\(user.username) have \(user.wallet) wallet. What a rich man !",
            ]
            let random = arc4random() % UInt32(walletTemplates.count)
            return walletTemplates[Int(random)]
        case "CorrectionPoints":
            let correctionTemplates = [
                "\(user.username) have actually \(user.correctionPoints) correction points.",
                "\(user.username) have \(user.correctionPoints) correction points.",
            ]
            let random = arc4random() % UInt32(correctionTemplates.count)
            return correctionTemplates[Int(random)]
        default:
            return "Here is the profil of \(user.username)."
        }
    }
    
    private func logResponse(username: String, location: String?) -> String {
        if location != nil {
            let availableTemplates = [
                "\(username) is located in \(location!).",
                "It looks like \(username) is in \(location!).",
                "\(username) is currently in \(location!). Say him hello !",
            ]
            let random = arc4random() % UInt32(availableTemplates.count)
            return availableTemplates[Int(random)]
        }
        else {
            let unavailableTemplate = [
                "\(username) is not available.",
                "\(username) is not at school.",
                "\(username) is not here. Blackhole is comming...",
            ]
            let random = arc4random() % UInt32(unavailableTemplate.count)
            return unavailableTemplate[Int(random)]
        }
    }
}
