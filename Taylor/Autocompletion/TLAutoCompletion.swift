//
//  TLAutoCompletion.swift
//  Taylor
//
//  Created by Benjamin Pisano on 05/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

class TLAutoCompletion: NSObject {
    
    struct shared {
        static var users = [String]()
        static var commands = [String]()
        static var projects = [String]()
    }
    
    func suggestions(text: String) -> [String] {
        guard let lastWord = text.split(separator: " ").map(String.init).last else {
            return []
        }
        
        var completion = [String]()
        
        readFiles()
        for user in shared.users {
            if user.hasPrefix(lastWord) {
                completion.append(user)
            }
        }
        for command in shared.commands {
            if command.hasPrefix(lastWord) {
                completion.append(command)
            }
        }
        for project in shared.projects {
            if project.hasPrefix(lastWord) {
                completion.append(project)
            }
        }
        return completion
    }
    
    private func readFile(named name: String) -> String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            return nil
        }
        
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    private func readFiles() {
        if shared.users.count == 0 {
            if let content = readFile(named: "users") {
                shared.users = content.split(separator: "\n").map(String.init).sorted(by: { (user1, user2) -> Bool in
                    user1 < user2
                })
            }
        }
        if shared.commands.count == 0 {
            if let content = readFile(named: "commands") {
                shared.commands = content.split(separator: "\n").map(String.init).sorted(by: { (command1, command2) -> Bool in
                    command1 < command2
                })
            }
        }
        if shared.projects.count == 0 {
            if let content = readFile(named: "projects") {
                shared.projects = content.split(separator: "\n").map(String.init).sorted(by: { (project1, project2) -> Bool in
                    project1 < project2
                })
            }
        }
    }
}
