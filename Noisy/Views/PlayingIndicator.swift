import SwiftUI

struct PlayingIndicator: View {
    private let speeds = [5.3, 7.1, 4.4, 6.2]

    var body: some View {
        TimelineView(.animation) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(speeds.indices, id: \.self) { index in
                    let level = 0.25 + 0.75 * abs(sin(time * speeds[index] / 2 + Double(index)))
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 3, height: 16 * level)
                }
            }
            .frame(height: 16, alignment: .bottom)
        }
        .foregroundStyle(.tint)
        .accessibilityLabel("Playing")
    }
}
