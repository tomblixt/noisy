import SwiftUI

struct SettingsView: View {
    @AppStorage(AppMode.storageKey) private var mode = AppMode.window
    @AppStorage(AppMode.showInDockKey) private var showInDock = true
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openURL) private var openURL

    private let systemSettingsURL = URL(string: "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?Audio")!

    var body: some View {
        Form {
            Section {
                Picker("Show Noisy in", selection: $mode) {
                    ForEach(AppMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                Toggle(isOn: $showInDock) {
                    Text("Show in Dock")
                    Text("Only available when Noisy lives in the menu bar.")
                }
                .disabled(mode != .menuBar)
            } header: {
                Text("General")
            }

            Section {
                LabeledContent {
                    Button("Open System Settings") { openURL(systemSettingsURL) }
                        .fixedSize()
                } label: {
                    Text("Background Sounds")
                    Text("Equaliser, timer and more.")
                }
            } header: {
                Text("System")
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .frame(width: 440)
        .fixedSize(horizontal: false, vertical: true)
        .onChange(of: mode) { _, mode in
            switch mode {
            case .window: openWindow(id: MyApp.mainWindowID)
            case .menuBar: dismissWindow(id: MyApp.mainWindowID)
            }
            AppMode.applyActivationPolicy(mode: mode, showInDock: showInDock)
        }
        .onChange(of: showInDock) { _, showInDock in
            AppMode.applyActivationPolicy(mode: mode, showInDock: showInDock)
        }
    }
}

