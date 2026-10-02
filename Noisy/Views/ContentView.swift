import SwiftUI

struct ContentView: View {
    @State private var sounds = BackgroundSounds()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(BackgroundSound.allCases) { sound in
                    SoundRow(
                        sound: sound,
                        isSelected: sound == sounds.selected,
                        isPlaying: sound == sounds.selected && sounds.isPlaying
                    ) {
                        sounds.play(sound)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollEdgeEffectStyle(.soft, for: .bottom)
        .safeAreaBar(edge: .bottom) {
            PlayerControls(sounds: sounds)
        }
        .frame(minWidth: 340, idealWidth: 400, minHeight: 360, idealHeight: 600)
        .task { await sounds.monitor() }
    }
}

#Preview {
    ContentView()
}
