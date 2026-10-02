import SwiftUI

struct PlayerControls: View {
    let sounds: BackgroundSounds

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                Button(action: sounds.togglePlayback) {
                    Image(systemName: sounds.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 60, height: 60)
                        .background(.tint, in: .circle)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(sounds.isPlaying ? "Pause" : "Play")

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sound")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(sounds.selected.title)
                        .font(.title3)
                }

                Spacer()

                TimerMenu(sounds: sounds)
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
