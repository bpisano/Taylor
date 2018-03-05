//
//  TLKeyword.swift
//  Taylor
//
//  Created by Benjamin Pisano on 02/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

struct TLKeyword {
    var key: String
    var value: String
    
    static func getKeywords(parameters: [String: Any?]?, exclude: [String]? = nil) -> [TLKeyword] {
        guard parameters != nil else {
            return []
        }
        
        var keywords = [TLKeyword]()
        
        for parameter in parameters! {
            guard let keywordValue = (parameter.value as? AIResponseParameter)?.stringValue else {
                continue
            }
            
            if keywordValue != "" {
                if let exclude = exclude {
                    if exclude.contains(parameter.key) {
                        continue
                    }
                }
                
                let keyword = TLKeyword(key: parameter.key, value: keywordValue)
                keywords.append(keyword)
            }
        }
        return keywords
    }
}

extension Array where Element == TLKeyword {
    func contains(keyword: String) -> Bool {
        if contains(where: { (element) -> Bool in
            return element.key == keyword
        }) {
            return true
        }
        return false
    }
    
    func keyword(key: String) -> TLKeyword? {
        for keyword in self {
            if keyword.key == key {
                return keyword
            }
        }
        return nil
    }
}
