//
//  StatusController.swift
//  Life-tracker
//
//  Created by Cummings, Dan on 8/29/19.
//  Copyright © 2019 Cummings, Dan. All rights reserved.
//

import Foundation
import Cocoa

class StatusController: NSObject, SettingsViewControllerDelegate {
    
    var statusItem: NSStatusItem?
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var userDefaults = UserDefaults.standard
    var indicator: StatusViewController?
 
    init(statusbaritem statusBar: NSStatusItem) {
        super.init()
        self.statusItem = statusBar
        
        if let item = statusItem {
            if let button = item.button {
                button.image = NSImage(named:NSImage.Name("EmptyIcon_22"))
                indicator = StatusViewController()
                if let style = userDefaults.string(forKey: "visibleindicator") {
                    indicator!.style = Timeframe.fromString(style)
                } else {
                    indicator!.style = .hour
                }
                indicator!.birth = userDefaults.object(forKey: "birthday") as? Date
                item.length = indicator!.view.frame.width
                button.addSubview(indicator!.view)
                button.action = #selector(self.togglePopover(_:))
                button.target = self
            }
            
            popover.contentViewController = SettingsViewController.freshController()
            (popover.contentViewController as? SettingsViewController)?.delegate = self
            if let birthday = userDefaults.object(forKey: "birthday") as? Date {
                (popover.contentViewController as? SettingsViewController)?.birth
                    = birthday
            }
            
            eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
                if let strongSelf = self, strongSelf.popover.isShown {
                    strongSelf.closePopover(sender: event)
                }
            }
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let item = statusItem {
            if let button = item.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                eventMonitor?.start()
            }
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

}

extension StatusController {
    func updateBirthday(_ birthday: Date) {
        userDefaults.set( birthday, forKey: "birthday")
        if indicator!.style! == .end {
            indicator?.birth = birthday
            indicator?.setTimes()
            indicator?.determineProgress()
        }
    }

    func updateIndicator(_ indicator: StatusViewController) {
        
        userDefaults.set(indicator.style?.toString(), forKey: "visibleindicator")
        
        if let item = statusItem {
            if let button = item.button {
                DispatchQueue.main.async {
                    let newIndicator = StatusViewController()
                    newIndicator.style = indicator.style
                    newIndicator.birth = indicator.birth
                    button.replaceSubview(self.indicator!.view, with: newIndicator.view)
                    self.indicator = newIndicator
                }
            }
        }
    }
}

extension Timeframe {
    func toString() -> String {
        let temp: String
        switch self {
        case .day:
            temp = "day"
            break
        case .end:
            temp = "end"
            break
        case .month:
            temp = "month"
            break
        case .year:
            temp = "year"
            break
        case .hour:
            temp = "hour"
        default:
            temp = "none"
        }
        return temp
    }
    
    static func fromString(_ style: String) -> Timeframe {
        let temp: Timeframe
        switch style {
        case "day":
            temp = .day
            break
        case "end":
            temp = .end
            break
        case "month":
            temp = .month
            break
        case "year":
            temp = .year
            break
        case "hour":
            temp = .hour
        default:
            temp = .day
        }
        return temp
    }
}



