import SwiftUI

struct TimerMenu: View {
    let sounds: BackgroundSounds

    private let options = [(5, "5 Minutes"), (15, "15 Minutes"), (30, "30 Minutes"), (45, "45 Minutes"), (60, "1 Hour"), (120, "2 Hours")]

    var body: some View {
        Menu {
            ForEach(options, id: \.0) { minutes, label in
                Button(label) { sounds.startTimer(minutes: minutes) }
            }
            if sounds.timerEnd != nil {
                Divider()
                Button("Turn Off Timer", role: .destructive, action: sounds.cancelTimer)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "timer")
                    .font(.title3)
                if let timerEnd = sounds.timerEnd {
                    Text(timerInterval: Date.now...max(timerEnd, .now), countsDown: true)
                        .monospacedDigit()
                }
            }
            .foregroundStyle(sounds.timerEnd == nil ? AnyShapeStyle(.primary) : AnyShapeStyle(.tint))
            .padding(.horizontal, sounds.timerEnd == nil ? 0 : 14)
            .frame(minWidth: 44, minHeight: 44)
            .glassEffect(.regular.interactive(), in: .capsule)
            .contentShape(.capsule)
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .menuIndicator(.hidden)
        .fixedSize()
        .animation(.default, value: sounds.timerEnd)
        .help("Sleep timer")
    }
}
