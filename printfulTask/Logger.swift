//
//  Logger.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation

class Logger {
    static func debug(_ input: String...) {
        let output = "🛠" + input.joined(separator: ", ")
        print(output)
    }
    
    static func warn(_ input: String...) {
        let output = "⚠️" + input.joined(separator: ", ")
        print(output)
    }
    
    static func err(_ input: String...) {
        let output = "⛔️" + input.joined(separator: ", ")
        print(output)
    }
    
    static func success(_ input: String...) {
        let output = "✅" + input.joined(separator: ", ")
        print(output)
    }
}
