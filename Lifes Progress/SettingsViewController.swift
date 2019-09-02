//
//  SettingsViewController.swift
//  Life-tracker
//
//  Created by Cummings, Dan on 8/27/19.
//  Copyright © 2019 Cummings, Dan. All rights reserved.
//

import Cocoa

protocol SettingsViewControllerDelegate {
    func updateBirthday(_ birthday: Date)
    func updateIndicator(_ indicator: StatusViewController)
}

class SettingsViewController: NSViewController {

    @IBOutlet weak var tableheader: NSTableHeaderView!
    @IBOutlet weak var timezone: NSPopUpButton!
    @IBOutlet weak var birthday: NSDatePicker!
    @IBOutlet weak var tableView: NSTableView!
    
    var birth: Date?
    var views: [StatusViewController?] = []
    
    var timezoneidentifiers = TimeZone.knownTimeZoneIdentifiers
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTimeframes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        tableView.action = #selector(itemSelected(_:))
        
        guard let date = birth else {
            return
        }
        self.birthday.dateValue = date
    }
    
    func createTimeframes() {
        let hour = StatusViewController()
        hour.style = .hour
        let month = StatusViewController()
        month.style = .month
        let year = StatusViewController()
        year.style = .year
        let day = StatusViewController()
        day.style = .day
        
        views.append(hour)
        views.append(day)
        views.append(month)
        views.append(year)
        guard let date = self.birth else {
            return
        }
        let end = StatusViewController()
        end.birth = date
        end.style = .end
        views.append(end)
    }
    
    @IBAction func changedBirthdate(_ sender: Any) {
        delegate?.updateBirthday((sender as? NSDatePicker)!.dateValue)
        self.birth = (sender as! NSDatePicker).dateValue
        self.views = []
        self.createTimeframes()
        tableView.reloadData()
    }
    
}

extension SettingsViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> SettingsViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("SettingsViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SettingsViewController else {
            fatalError("Why cant i find SettingsViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension SettingsViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return views.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return views[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return views[row]?.view
    }
    
    @objc func itemSelected(_ sender: Any?) {
        if (tableView.clickedRow >= 0 && tableView.clickedRow <= views.count) {
            delegate?.updateIndicator(views[tableView.clickedRow]!)
        }
    }
}
