//
//  StatusViewController.swift
//  Life-tracker
//
//  Created by Cummings, Dan on 8/29/19.
//  Copyright © 2019 Cummings, Dan. All rights reserved.
//

import Cocoa

enum Timeframe {
    case year
    case month
    case day
    case hour
    case end
}

class StatusViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var titleLabel: NSTextField!
    var name: String?
    var start: Date?
    var end: Date?
    var delegate: AppDelegate?
    var style: Timeframe?
    var timer: Timer?
    var birth: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTimes()
        self.determineProgress()
        titleLabel.backgroundColor = .clear
        titleLabel.stringValue = "\(name!): \(String(format: "%.01f", progressIndicator.doubleValue))%"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.setTimes()
            self.determineProgress()
            }
    }
    
    func setTimes() {
        switch style! {
        case .year:
            let year = Calendar.current.component(.year, from: Date())
            self.start = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
            self.end = Calendar.current.date(from: DateComponents(year: year+1, month: 1, day: 1))
            self.name = "Year"
            break
        case .month:
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            self.start = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
            self.end = Calendar.current.date(from: DateComponents(year: year, month: month+1, day: 1))
            self.name = "Month"
            break
        case .day:
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            self.start = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
            self.end = Calendar.current.date(from: DateComponents(year: year, month: month, day: day+1))
            self.name = "Day"
            break
        case .hour:
            let hour = Calendar.current.component(.hour, from: Date())
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            self.start = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, second: 0))
            self.end = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour+1, second: 0))
            self.name = "Hour"
            break
        case .end:
//           78 years 7 months 2 days
            guard let birth = self.birth else {
                break
            }
            self.start = birth
            let year = Calendar.current.component(.year, from: birth)
            let month = Calendar.current.component(.month, from: birth)
            let day = Calendar.current.component(.day, from: birth)
            self.end = Calendar.current.date(from: DateComponents(year: year + 78, month: month + 7, day: day + 2))
            self.name = "Life"
            break
        default:
            print("Style was not set")
        }
    }
    
    func determineProgress() {
        guard let startTime = start, let endTime = end else {
            print("Times are not yet set")
            return
        }
        self.progressIndicator.doubleValue = (Date().timeIntervalSince(startTime)) / (endTime.timeIntervalSince(startTime)) * 100
        self.titleLabel.stringValue = "\(name!): \(String(format: "%.01f", progressIndicator.doubleValue))%"
    }
    
    @objc func updateProgress(_ sender: Any?) {
        self.setTimes()
        self.determineProgress()
    }
}
