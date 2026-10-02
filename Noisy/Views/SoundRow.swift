import SwiftUI

struct SoundRow: View {
    let sound: BackgroundSound
    let isSelected: Bool
    let isPlaying: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: sound.symbol)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(.quaternary, in: .rect(cornerRadius: 10))

                HStack {
                    Text(sound.title)
                        .font(.title3)
                        .foregroundStyle(isPlaying ? Color.accentColor : .primary)
                    Spacer()
                    if isPlaying {
                        PlayingIndicator()
                    } else if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.tint)
                    }
                }
                .padding(.trailing, 8)
                .frame(maxHeight: .infinity)
                .overlay(alignment: .bottom) { Divider() }
            }
            .frame(height: 64)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
