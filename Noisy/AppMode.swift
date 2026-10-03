import AppKit

enum AppMode: String, CaseIterable, Identifiable {
    case window
    case menuBar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .window: "Window"
        case .menuBar: "Menu Bar"
        }
    }

    static let storageKey = "appMode"
    static let showInDockKey = "showInDock"

    static func applyActivationPolicy(mode: AppMode, showInDock: Bool) {
        let policy: NSApplication.ActivationPolicy = mode == .menuBar && !showInDock ? .accessory : .regular
        guard NSApp.activationPolicy() != policy else { return }
        NSApp.setActivationPolicy(policy)
        if policy == .regular { NSApp.activate() }
    }
}
