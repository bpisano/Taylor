//
//  FTRandomSentence.swift
//  Taylor
//
//  Created by Benjamin Pisano on 02/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa

struct FTResponseArray {
    var responses: [String]
    
    func random() -> String {
        guard responses.count > 0 else {
            return String()
        }
        
        let random = arc4random() % UInt32(responses.count)
        return responses[Int(random)]
    }
}
