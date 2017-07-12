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
                    
                    let arg =   "tell application \"System Events\"\n" +
                                    // Check if Terminal.app is running
                                    "if (application process \"Terminal\" exists) then\n" +
                                        // if Terminal.app is running make sure it is in the foreground
                                        "tell application \"Terminal\"\n" +
                                            "activate\n" +
                        
                                            "if (exists window 1) then\n" +
                                                "tell application \"System Events\" to keystroke \"t\" using command down\n" +
                                                "do script \"cd '\(url.path)' && clear\" in window 1\n" +
                                            "else\n" +
                                                "do script \"cd '\(url.path)' && clear\"\n" +
                                            "end if\n" +
                        
                                        "end tell\n" +
                        
                        
                                    "else\n" +
                                        "do script \"\"\n" +
                                        // If Terminal.app is not running bring it up
                                        "tell application \"Terminal\"\n" +
                                            "activate\n" +
                                            "do script \"cd '\(url.path)' && clear\"\n" +
                        
                                            "if (exists window 1) then\n" +
                                                "tell application \"System Events\" to keystroke \"t\" using command down\n" +
                                                "do script \"cd '\(url.path)' && clear\" in window 1\n" +
                                            "else\n" +
                                                "do script \"cd '\(url.path)' && clear\"\n" +
                                            "end if\n" +
                        
                                        "end tell\n" +
                                    "end if\n" +
                                "end tell\n"
                    
                    
                    let arg_v2 = "set dirPath to POSIX path of '\(url.path)' \n" +
                                "if application \"Terminal\" is running then\n" +
                                    "tell application \"System Events\" to set InCurrentDesktop to windows of process \"Terminal\"\n" +
                                    "tell application \"Terminal\"\n" +
                                        "if length of InCurrentDesktop is 0 then\n" +
                                            "tell application \"Terminal\"\n" +
                                                "do script \"cd dirPath && clear\"\n" +
                                                "activate\n" +
                                            "end tell\n" +
                                        "else\n" +
                                            "activate\n" +
                                            "if (exists window 1) then\n" +
                                                "tell application \"System Events\" to keystroke \"t\" using command down\n" +
                                                    "do script \"cd dirPath && clear\" in window 1\n" +
                                            "else\n" +
                                                "do script \"cd dirPath && clear\"\n" +
                                            "end if\n" +
                                        "end if\n" +
                                    "end tell\n" +
                                "else\n" +
                                    "tell application \"Terminal\"\n" +
                                            "if (exists window 1) then\n" +
                                                "do script \"cd dirPath && clear\" in window 1\n" +
                                                "activate\n" +
                                            "end if\n" +
                                    "end tell\n" +
                                "end if\n"
                    
                    let arg_v3 = "if application \"Terminal\" is running then\n" +
                                    "tell application \"System Events\" to set InCurrentDesktop to windows of process \"Terminal\"\n" +
                                    "tell application \"Terminal\"\n" +
                                        "if length of InCurrentDesktop is 0 then\n" +
                                            "tell application \"Terminal\"\n" +
                                                "do script \"cd '\(url.path)' && clear\"\n" +
                                                "activate\n" +
                                            "end tell\n" +
                                        "else\n" +
                                            "activate\n" +
                                            "if (exists window 1) then\n" +
                                                "tell application \"System Events\" to keystroke \"t\" using command down\n" +
                                                    "do script \"cd '\(url.path)' && clear\" in window 1\n" +
                                            "else\n" +
                                                "do script \"cd '\(url.path)' && clear\"\n" +
                                            "end if\n" +
                                        "end if\n" +
                                    "end tell\n" +
                                "else\n" +
                                    "tell application \"Terminal\"\n" +
                                            "if (exists window 1) then\n" +
                                                "do script \"cd '\(url.path)' && clear\" in window 1\n" +
                                                "activate\n" +
                                            "end if\n" +
                                    "end tell\n" +
                                "end if\n"
                    
                    SwiftySystem.execute("/usr/bin/osascript", arguments: ["-e", arg_v3])
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

