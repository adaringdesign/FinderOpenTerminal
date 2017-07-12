//
//  SwiftySystem.swift
//  Open in Terminal
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Modified by Rutger Valk-van de Klundert
//  Copyright © 2017 A Daring Design. All rights reserved.
//

import Foundation

struct SwiftySystem {
    static func execute(_ path: String?, arguments: [String]?) {
        let pipe = Pipe()
        
        let task = Process()
        task.launchPath = path
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        
        task.waitUntilExit()
    }
}
