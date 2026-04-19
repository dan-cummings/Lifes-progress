//
//  AppDelegate.swift
//  Lifes Progress
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var statusController: StatusController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusController = StatusController(statusBarItem: statusItem)
    }
}
