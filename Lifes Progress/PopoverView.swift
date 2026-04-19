//
//  PopoverView.swift
//  Lifes Progress
//
//  Modern SwiftUI popover showing circular progress rings for each timeframe.
//

import SwiftUI

struct PopoverView: View {
    @ObservedObject var model: ProgressModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Life's Progress")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            // Progress rings in a compact 3-column grid
            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(model.visibleTimeframes) { timeframe in
                    Button {
                        model.selectTimeframe(timeframe)
                    } label: {
                        ProgressRingView(
                            timeframe: timeframe,
                            progress: model.progress[timeframe] ?? 0,
                            isSelected: model.selectedTimeframe == timeframe
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            // Birthday section
            HStack(spacing: 6) {
                Image(systemName: "birthday.cake")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                if let birthday = model.birthday {
                    Text(birthday, style: .date)
                        .font(.caption)
                } else {
                    Text("Set birthday for Life tracker")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                DatePicker("", selection: Binding(
                    get: { model.birthday ?? Date() },
                    set: { model.setBirthday($0) }
                ), displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(width: 100)
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption2)
        }
        .padding(14)
        .frame(width: 300)
    }
}

// MARK: - Progress Ring

struct ProgressRingView: View {
    let timeframe: Timeframe
    let progress: Double
    let isSelected: Bool

    private let ringSize: CGFloat = 52
    private let lineWidth: CGFloat = 5

    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                // Background track
                Circle()
                    .stroke(timeframe.color.opacity(0.12), lineWidth: lineWidth)

                // Animated progress arc
                Circle()
                    .trim(from: 0, to: progress / 100)
                    .stroke(
                        timeframe.color.gradient,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: progress)

                // Center percentage
                Text(String(format: "%.0f%%", progress))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .monospacedDigit()
            }
            .frame(width: ringSize, height: ringSize)

            // Label with icon
            HStack(spacing: 2) {
                Image(systemName: timeframe.icon)
                    .font(.system(size: 8))
                Text(timeframe.displayName)
                    .font(.system(size: 10, design: .rounded))
            }
            .fontWeight(.medium)
            .foregroundStyle(isSelected ? timeframe.color : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isSelected ? timeframe.color.opacity(0.08) : Color.clear)
        )
        .contentShape(Rectangle())
    }
}
