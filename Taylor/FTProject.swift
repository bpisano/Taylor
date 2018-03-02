//
//  FTProject.swift
//  42IA
//
//  Created by Benjamin Pisano on 01/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

enum FTProjectStatus {
    case finished
    case inProgress
}

struct FTProject {
    var id: String
    var name: String
    var displayName: String
    var status: FTProjectStatus
    var validated: Bool
    var mark: Int
    var cursusID: String
}
