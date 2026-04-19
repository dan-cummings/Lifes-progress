//
//  StatusController.swift
//  Lifes Progress
//

import Cocoa
import SwiftUI

class StatusController {

    let statusItem: NSStatusItem
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let model = ProgressModel()
    private var timer: Timer?

    init(statusBarItem: NSStatusItem) {
        self.statusItem = statusBarItem

        if let button = statusItem.button {
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
            button.title = model.statusBarText
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        let hostingController = NSHostingController(rootView: PopoverView(model: model))
        popover.contentViewController = hostingController
        popover.behavior = .transient

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self, self.popover.isShown {
                self.closePopover(sender: event)
            }
        }

        // Refresh the status bar text every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.statusItem.button?.title = self.model.statusBarText
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
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
