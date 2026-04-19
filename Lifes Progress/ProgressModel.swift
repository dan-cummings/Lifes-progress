//
//  ProgressModel.swift
//  Lifes Progress
//
//  Modern observable data model for tracking time progress.
//

import Foundation
import SwiftUI

enum Timeframe: String, CaseIterable, Identifiable {
    case hour
    case day
    case month
    case year
    case life

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hour: return "Hour"
        case .day: return "Day"
        case .month: return "Month"
        case .year: return "Year"
        case .life: return "Life"
        }
    }

    var icon: String {
        switch self {
        case .hour: return "clock"
        case .day: return "sun.max"
        case .month: return "calendar"
        case .year: return "globe"
        case .life: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .hour: return .blue
        case .day: return .orange
        case .month: return .green
        case .year: return .purple
        case .life: return .red
        }
    }
}

class ProgressModel: ObservableObject {
    @Published var birthday: Date?
    @Published var selectedTimeframe: Timeframe = .day
    @Published var progress: [Timeframe: Double] = [:]

    /// Called when the status bar text needs an immediate refresh.
    var onStatusBarUpdate: (() -> Void)?

    private var timer: Timer?

    /// The timeframes that should be visible (life requires a birthday)
    var visibleTimeframes: [Timeframe] {
        Timeframe.allCases.filter { $0 != .life || birthday != nil }
    }

    init() {
        // Load saved preferences, migrating "end" -> "life" from old versions
        if let saved = UserDefaults.standard.string(forKey: "visibleindicator") {
            let migrated = saved == "end" ? "life" : saved
            selectedTimeframe = Timeframe(rawValue: migrated) ?? .day
        } else {
            selectedTimeframe = .day
        }
        birthday = UserDefaults.standard.object(forKey: "birthday") as? Date

        updateProgress()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    func selectTimeframe(_ timeframe: Timeframe) {
        selectedTimeframe = timeframe
        UserDefaults.standard.set(timeframe.rawValue, forKey: "visibleindicator")
        onStatusBarUpdate?()
    }

    func setBirthday(_ date: Date?) {
        birthday = date
        UserDefaults.standard.set(date, forKey: "birthday")
        updateProgress()
        onStatusBarUpdate?()
    }

    func updateProgress() {
        let now = Date()
        let calendar = Calendar.current

        for timeframe in Timeframe.allCases {
            guard let (start, end) = bounds(for: timeframe, at: now, calendar: calendar) else {
                continue
            }
            let total = end.timeIntervalSince(start)
            let elapsed = now.timeIntervalSince(start)
            progress[timeframe] = min(max(elapsed / total * 100, 0), 100)
        }
    }

    var statusBarText: String {
        let pct = progress[selectedTimeframe] ?? 0
        return "\(selectedTimeframe.displayName) \(String(format: "%.1f", pct))%"
    }

    // MARK: - Private

    private func bounds(for timeframe: Timeframe, at now: Date, calendar: Calendar) -> (Date, Date)? {
        switch timeframe {
        case .hour:
            let comps = calendar.dateComponents([.year, .month, .day, .hour], from: now)
            guard let start = calendar.date(from: comps),
                  let end = calendar.date(byAdding: .hour, value: 1, to: start) else { return nil }
            return (start, end)

        case .day:
            let start = calendar.startOfDay(for: now)
            guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return nil }
            return (start, end)

        case .month:
            let comps = calendar.dateComponents([.year, .month], from: now)
            guard let start = calendar.date(from: comps),
                  let end = calendar.date(byAdding: .month, value: 1, to: start) else { return nil }
            return (start, end)

        case .year:
            let comps = calendar.dateComponents([.year], from: now)
            guard let start = calendar.date(from: comps),
                  let end = calendar.date(byAdding: .year, value: 1, to: start) else { return nil }
            return (start, end)

        case .life:
            guard let birth = birthday else { return nil }
            // Average life expectancy: ~78 years 7 months
            guard let end = calendar.date(byAdding: DateComponents(year: 78, month: 7, day: 2), to: birth) else { return nil }
            return (birth, end)
        }
    }
}
