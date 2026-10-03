import SwiftUI

struct PlayerControls: View {
    let sounds: BackgroundSounds

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                Button(action: sounds.togglePlayback) {
                    Image(systemName: sounds.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 48, height: 48)
                        .glassEffect(.regular.tint(.accentColor).interactive(), in: .circle)
                }
                .buttonStyle(.plain)
                .disabled(sounds.selected == nil)
                .accessibilityLabel(sounds.isPlaying ? "Pause" : "Play")

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sound")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(sounds.selected?.title ?? "None")
                        .font(.title3)
                }

                Spacer()

                TimerMenu(sounds: sounds)
                    .disabled(sounds.selected == nil)
            }

            HStack(spacing: 10) {
                Image(systemName: "speaker.fill")
                Slider(value: Binding(get: { sounds.volume }, set: sounds.setVolume), in: 0...1)
                Image(systemName: "speaker.wave.3.fill")
            }
            .foregroundStyle(.secondary)
        }
        .padding(20)
    }
}
