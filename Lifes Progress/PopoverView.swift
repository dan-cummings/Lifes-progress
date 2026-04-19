//
//  PopoverView.swift
//  Lifes Progress
//
//  Modern SwiftUI popover showing circular progress rings for each timeframe.
//

import SwiftUI

struct PopoverView: View {
    @Bindable var model: ProgressModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Life's Progress")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.top, 4)

            // Progress rings in a 2-column grid
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(model.visibleTimeframes) { timeframe in
                    ProgressRingView(
                        timeframe: timeframe,
                        progress: model.progress[timeframe] ?? 0,
                        isSelected: model.selectedTimeframe == timeframe
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            model.selectedTimeframe = timeframe
                        }
                    }
                    .contentShape(Rectangle())
                }
            }

            Divider()

            // Birthday section
            HStack {
                Image(systemName: "birthday.cake")
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
                    set: { model.birthday = $0 }
                ), displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(width: 100)
            }

            Button("Quit Life's Progress") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
        }
        .padding(20)
        .frame(width: 280)
    }
}

// MARK: - Progress Ring

struct ProgressRingView: View {
    let timeframe: Timeframe
    let progress: Double
    let isSelected: Bool

    private let ringSize: CGFloat = 76
    private let lineWidth: CGFloat = 7

    var body: some View {
        VStack(spacing: 6) {
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

                // Center icon + percentage
                VStack(spacing: 1) {
                    Image(systemName: timeframe.icon)
                        .font(.system(size: 13))
                        .foregroundStyle(timeframe.color)

                    Text(String(format: "%.1f%%", progress))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                }
            }
            .frame(width: ringSize, height: ringSize)

            Text(timeframe.displayName)
                .font(.system(.caption, design: .rounded))
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? timeframe.color : .secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? timeframe.color.opacity(0.08) : Color.clear)
        )
    }
}
