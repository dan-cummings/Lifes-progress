//
//  AppDelegate.swift
//  Life-tracker
// Template generated from: https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos
//  Created by Cummings, Dan on 8/27/19.
//  Copyright © 2019 Cummings, Dan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: 150.0)
    var statusController: StatusController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusController = StatusController(statusbaritem: statusItem)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

