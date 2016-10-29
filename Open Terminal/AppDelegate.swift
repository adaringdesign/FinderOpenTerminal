//
//  AppDelegate.swift
//  Open Terminal
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import Darwin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        let appleEventManager:NSAppleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        SwiftySystem.execute("/usr/bin/pluginkit", arguments: ["pluginkit", "-e", "use", "-i", "fr.qparis.openterminal.Open-Terminal-Finder-Extension"])
        SwiftySystem.execute("/usr/bin/killall",arguments: ["Finder"])
        helpMe()
        exit(0)
    }
    
    func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let url = URL(string: event!.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!) {
            if url.path.characters.count > 0 {
                if(FileManager.default.fileExists(atPath: url.path)) {
                    SwiftySystem.execute("/usr/bin/open", arguments: ["-b", "com.apple.terminal", "-n", "--args", "cd", url.path])
                } else {
                    let error = NSLocalizedString("pathError", comment: "Missing directory message")
                    helpMe(error)
                }
            }
        }
        exit(0)
    }
    
    fileprivate func helpMe(_ customMessage: String) {
        let alert = NSAlert ()
        alert.messageText = "Information"
        alert.informativeText = customMessage
        alert.runModal()
    }
    
    fileprivate func helpMe() {
        let info = NSLocalizedString("information", comment: "Information presented on startup")
        helpMe(info + "\n\n(c) Quentin PÂRIS 2016 - http://quentin.paris")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

