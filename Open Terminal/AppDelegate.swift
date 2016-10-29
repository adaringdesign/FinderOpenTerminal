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

                    do {
                        let rcContent = "cd \""+url.path+"\" \n" +
                            "[ -e \"$HOME/.profile\" ] && rcFile=\"~/.profile\" || rcFile=\"/etc/profile\"\n" +
                            "exec bash -c \"clear;printf '\\e[3J';bash --rcfile $rcFile\""
                        
                        try (rcContent).write(toFile: "/tmp/openTerminal", atomically: true, encoding: String.Encoding.utf8)
                        try FileManager.default.setAttributes([FileAttributeKey.posixPermissions: 0o777], ofItemAtPath: "/tmp/openTerminal")
                            SwiftySystem.execute("/usr/bin/open", arguments: ["-b", "com.apple.terminal", "/tmp/openTerminal"])
                    } catch _ {}
                    
                } else {
                    helpMe("The specified directory does not exist")
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
        helpMe("This application adds a Open Terminal item in every Finder context menus.\n\n(c) Quentin PÂRIS 2016 - http://quentin.paris")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

