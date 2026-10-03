import AppKit
import SwiftUI

struct ContentView: View {
    @State private var sounds = BackgroundSounds()
    @State private var isScrolledToBottom = false

    var body: some View {
        List(BackgroundSound.allCases) { sound in
            SoundRow(
                sound: sound,
                isSelected: sound == sounds.selected,
                isPlaying: sound == sounds.selected && sounds.isPlaying
            ) {
                if sound == sounds.selected && sounds.isPlaying {
                    sounds.togglePlayback()
                } else {
                    sounds.play(sound)
                }
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.visibleRect.maxY >= geometry.contentSize.height + geometry.contentInsets.bottom - 1
        } action: { _, isAtBottom in
            withAnimation { isScrolledToBottom = isAtBottom }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PlayerControls(sounds: sounds)
                .background {
                    BackdropBlur()
                        .mask(LinearGradient(stops: [.init(color: .clear, location: 0), .init(color: .black, location: 0.35)], startPoint: .top, endPoint: .bottom))
                        .padding(.top, -40)
                        .ignoresSafeArea()
                        .opacity(isScrolledToBottom ? 0 : 1)
                }
        }
        .frame(minWidth: 340, idealWidth: 400, minHeight: 360, idealHeight: 600)
        .task { await sounds.monitor() }
    }
}

private struct BackdropBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .withinWindow
        view.material = .hudWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
