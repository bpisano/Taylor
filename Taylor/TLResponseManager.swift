//
//  TLResponseTemplate.swift
//  42IA
//
//  Created by Benjamin Pisano on 28/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

class TLResponseManager: NSObject {
    
    func response(intentName: String, parameters: [String: Any?]?) -> TLResponse? {
        guard let parameters = parameters else {
            return nil
        }
        
        let user = parameters["user"] as! FTUser
        let params = parameters["parameters"] as? [String: Any]
        
        switch intentName {
        case "Log":
            return TLResponse(response: logResponse(user: user),
                              view: TLViewManager().logView(user: user))
        case "Profil":
            return TLResponse(response: profilResponse(user: user, parameters: params),
                              view: TLViewManager().profilView(user: user))
        case "Projects":
            return TLResponse(response: projectResponse(user: user, parameters: params),
                              view: TLViewManager().projectView(user: user, parameters: params))
        default:
            return nil
        }
    }
    
    private func projectResponse (user: FTUser, parameters: [String: Any?]?) -> String? {
        var keywords = TLKeyword.getKeywords(parameters: parameters, exclude: ["User"])
        
        guard let projectName = keywords.keyword(key: "Project")?.value, let project = user.project(name: projectName) else {
            return "It seems that \(user.username) does not have started this project"
        }
        
        keywords = TLKeyword.getKeywords(parameters: parameters, exclude: ["User", "Project"])
        
        guard let keyword = keywords.first else {
            return "Here is the \(projectName) of \(user.username)."
        }
        
        switch keyword.key {
        case "ProjectStatus":
            if keyword.value == "start" {
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
        let keywords = TLKeyword.getKeywords(parameters: parameters, exclude: ["User", "Profil"])
        
        guard let keyword = keywords.first else {
            return TLResponseArray(responses: ["Here is the profil of \(user.username).",
                                                "Here it is. That's \(user.username) !",
                                                "\(user.username)... Okay here it is. Big applause."]).random()
        }
        
        if keyword.key == "Level" {
            return TLResponseArray(responses:["Here is the \(keyword.value) of \(user.username).",
                "\(user.username) is actually at level \(user.level).",
                "\(user.username) is at level \(user.level). Can be better..."]).random()
        }
        else if keyword.key == "Wallet" {
            return TLResponseArray(responses: ["\(user.username) have actually \(user.wallet) wallets.",
                "\(user.username) have \(user.wallet) wallet. What a rich man !"]).random()
        }
        else if keyword.key == "CorrectionPoints" {
            return TLResponseArray(responses: ["\(user.username) have actually \(user.correctionPoints) correction points.",
                "\(user.username) have \(user.correctionPoints) correction points."]).random()
        }
        else {
            return "Here is the profil of \(user.username)."
        }
    }
    
    private func logResponse(user: FTUser) -> String {
        guard let location = user.location else {
            return TLResponseArray(responses: ["\(user.username) is not available.",
                                                "\(user.username) is not at school.",
                                                "\(user.username) is not here. Blackhole is comming..."]).random()
        }
        return TLResponseArray(responses: ["\(user.username) is located in \(location).",
                                            "It looks like \(user.username) is in \(location).",
                                            "\(user.username) is currently in \(location). Say him hello !"]).random()
    }
}
