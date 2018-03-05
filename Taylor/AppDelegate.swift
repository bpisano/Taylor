//
//  AppDelegate.swift
//  Taylor
//
//  Created by Benjamin Pisano on 02/03/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import Cocoa
import ApiAI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: TLEventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        eventMonitor = TLEventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.showUI()
            }
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
            button.action = #selector(AppDelegate.showUI)
        }
        
        configureDialogAPI()
        configure42API()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func configureDialogAPI() {
        let config = AIDefaultConfiguration()
        config.clientAccessToken = "273b11f8daea4bf1bbe986990c74b2cc"
        
        let api = ApiAI.shared()
        api?.configuration = config
    }
    
    func configure42API() {
        FTApi().getToken(nil)
    }
    
    @objc func showUI() {
        guard let button = statusItem.button else {
            return
        }
        
        if popover.isShown {
            popover.performClose(nil)
            eventMonitor?.stop()
        }
        else {
            popover.contentViewController = TLMainViewController.newViewController()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
}

extension NSView {
    func named(_ name: String) -> NSView? {
        var topLevelObjects: NSArray?
        guard Bundle.main.loadNibNamed(NSNib.Name(name), owner: self, topLevelObjects: &topLevelObjects) else {
            return nil
        }
        
        return topLevelObjects!.first(where: { $0 is NSView }) as? NSView
    }
}

