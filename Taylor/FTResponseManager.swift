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
        case "Projects":
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
    /*
    private func projectResponse (user: FTUser, parameters: [String: Any?]?) -> String? {
        let keywords = FTKeyword.getKeywords(parameters: parameters, exclude: ["User"])
        
        guard keywords.contains(keyword: "Project") else {
            return "It seems that this project does not exist :/"
        }
        
        guard let projectName = keywords.keyword(key: "Project") else {
            return "It seems that \(user.username) does not have started this project"
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
    }*/
    
    private func profilResponse(user: FTUser, parameters: [String: Any?]?) -> String? {
        let keywords = FTKeyword.getKeywords(parameters: parameters, exclude: ["User", "Profil"])
        
        guard let keyword = keywords.first else {
            return FTResponseArray(responses: ["Here is the profil of \(user.username).",
                                                "Here it is. That's \(user.username) !",
                                                "\(user.username)... Okay here it is. Big applause."]).random()
        }
        
        if keyword.key == "Level" {
            return FTResponseArray(responses: ["Here is the \(keyword.value) of \(user.username).",
                "\(user.username) is actually at level \(user.level).",
                "\(user.username) is at level \(user.level). Can be better..."]).random()
        }
        else if keyword.key == "Wallet" {
            return FTResponseArray(responses: ["\(user.username) have actually \(user.wallet) wallets.",
                "\(user.username) have \(user.wallet) wallet. What a rich man !"]).random()
        }
        else if keyword.key == "CorrectionPoints" {
            return FTResponseArray(responses: ["\(user.username) have actually \(user.correctionPoints) correction points.",
                "\(user.username) have \(user.correctionPoints) correction points."]).random()
        }
        else {
            return "Here is the profil of \(user.username)."
        }
    }
    
    private func logResponse(username: String, location: String?) -> String {
        guard location != nil else {
            return FTResponseArray(responses: ["\(username) is not available.",
                                                "\(username) is not at school.",
                                                "\(username) is not here. Blackhole is comming..."]).random()
        }
        return FTResponseArray(responses: ["\(username) is located in \(location!).",
                                            "It looks like \(username) is in \(location!).",
                                            "\(username) is currently in \(location!). Say him hello !"]).random()
    }
}
