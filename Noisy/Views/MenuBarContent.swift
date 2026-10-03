import SwiftUI

struct MenuBarContent: View {
    let sounds: BackgroundSounds

    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(spacing: 0) {
            ContentView(sounds: sounds)
                .environment(\.selectionTint, .primary)
                .environment(\.playingIndicatorColor, Self.solidPrimary)

            Divider()

            HStack {
                Button(action: showSettings) {
                    Image(systemName: "gearshape")
                }
                .help("Settings")

                Spacer()

                Button("Quit Noisy") { NSApp.terminate(nil) }
            }
            .buttonStyle(.borderless)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 360, height: 560)
    }

    private static let solidPrimary = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? .white : .black
    })

    private func showSettings() {
        openSettings()
        // Without a Dock icon the Settings window can open behind other apps, so pull it forward.
        Task {
            await Task.yield()
            NSApp.activate()
            let settingsWindow = NSApp.windows.first {
                $0.identifier?.rawValue.contains("Settings") == true || $0.title.hasSuffix("Settings")
            }
            settingsWindow?.makeKeyAndOrderFront(nil)
            settingsWindow?.orderFrontRegardless()
        }
    }
}
