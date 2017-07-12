//
//  FinderSync.swift
//  FinderExtension
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    var myFolderURL: URL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath)
        
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
    }
    
    
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "Open Terminal")
        let title = NSLocalizedString("itemTitle", comment: "The title for the item shown in the context menu")
        menu.addItem(withTitle: title, action: #selector(FinderSync.openTerminal(_:)), keyEquivalent: "")
        return menu
    }
    
    @IBAction func openTerminal(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()

        guard let targetPath = target?.path.replacingOccurrences(of: " ", with: "%20"), let url = URL(string:"terminal://"+targetPath)  else {
            return
        }
        
        NSWorkspace.shared().open(url)
    }
    
}

