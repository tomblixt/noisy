import AppKit
import SwiftUI

@main struct MyApp: App {
    static let mainWindowID = "main"

    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage(AppMode.storageKey) private var mode = AppMode.window
    @AppStorage(AppMode.showInDockKey) private var showInDock = true

    init() {
        let defaults = UserDefaults.standard
        let mode = defaults.string(forKey: AppMode.storageKey).flatMap(AppMode.init) ?? .window
        let showInDock = defaults.object(forKey: AppMode.showInDockKey) as? Bool ?? true
        if mode == .menuBar && !showInDock {
            NSApplication.shared.setActivationPolicy(.accessory)
        }
    }

    private var sounds: BackgroundSounds { appDelegate.sounds }

    var body: some Scene {
        Window("Noisy", id: Self.mainWindowID) {
            ContentView(sounds: sounds)
                .frame(minWidth: 340, idealWidth: 400, maxWidth: 520, minHeight: 360, idealHeight: 600)
                .windowFullScreenBehavior(.disabled)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 400, height: 600)
        .windowResizability(.contentSize)
        .defaultLaunchBehavior(mode == .menuBar ? .suppressed : .presented)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Noisy", action: showAboutPanel)
            }
        }

        MenuBarExtra(isInserted: .constant(mode == .menuBar)) {
            MenuBarContent(sounds: sounds)
        } label: {
            Image(nsImage: Self.menuBarIcon)
                .accessibilityLabel("Noisy")
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }

    private static let menuBarIcon: NSImage = {
        let image = NSImage(resource: .menuIcon)
        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
        return image
    }()

    private func showAboutPanel() {
        let repository = "https://github.com/tomblixt/noisy"
        let credits = NSAttributedString(string: "github.com/tomblixt/noisy", attributes: [
            .link: URL(string: repository)!,
            .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
        ])
        NSApplication.shared.orderFrontStandardAboutPanel(options: [.credits: credits])
    }
}
