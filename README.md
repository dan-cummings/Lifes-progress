# Life's Progress

A macOS menu bar app that shows how much of the current hour, day, month and
year has elapsed, as a percentage. Give it a birthday and it also shows how
much of an average lifespan (78 years 7 months) has passed.

## Features

- Lives in the menu bar only (no Dock icon); the selected timeframe's
  percentage is shown as the status item's text and refreshes every second.
- Clicking the status item opens a SwiftUI popover with a circular progress
  ring for each timeframe: Hour, Day, Month, Year and, once a birthday is set,
  Life.
- Picking a ring makes that timeframe the one shown in the menu bar.
- The chosen timeframe and the birthday persist between launches in
  `UserDefaults`.
- A Quit button at the bottom of the popover closes the app.

## Requirements

- macOS 14 or later
- Xcode 15 or later

## Building

Open `Lifes Progress.xcodeproj` in Xcode and run the `Lifes Progress` scheme.

## Project structure

| Path | Contents |
|---|---|
| `Lifes Progress/AppDelegate.swift` | App entry point; creates the status bar controller |
| `Lifes Progress/StatusController.swift` | Status bar item and the popover that hosts the SwiftUI view |
| `Lifes Progress/PopoverView.swift` | Progress rings and the birthday picker |
| `Lifes Progress/ProgressModel.swift` | Timeframes, the progress calculation and saved preferences |
| `Lifes ProgressTests/`, `Lifes ProgressUITests/` | Unit and UI test targets |
