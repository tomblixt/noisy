import SwiftUI

struct SoundRow: View {
    let sound: BackgroundSound
    let isSelected: Bool
    let isPlaying: Bool
    let action: () -> Void

    @Environment(\.selectionTint) private var selectionTint
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: sound.symbol)
                    .font(.title2)
                    .opacity(isHovering ? 0 : 1)
                    .frame(width: 48, height: 48)
                    .background(.quaternary, in: .rect(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.separator.opacity(0.5), lineWidth: 1)
                    }
                    .overlay {
                        if isHovering {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black.opacity(0.5), in: .rect(cornerRadius: 10))
                                .transition(.opacity)
                        }
                    }

                HStack {
                    Text(sound.title)
                        .font(.title3)
                        .foregroundStyle(isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(.primary))
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
            }
            .padding(.vertical, 4)
            .contentShape(.rect)
            .tint(selectionTint)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) { isHovering = hovering }
        }
    }
}

extension EnvironmentValues {
    @Entry var selectionTint: Color = .accentColor
}
