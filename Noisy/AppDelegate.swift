import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    let sounds = BackgroundSounds()

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        sounds.refresh()
        let menu = NSMenu()
        menu.autoenablesItems = false
        let item = NSMenuItem(
            title: sounds.isPlaying ? "Pause" : "Play",
            action: #selector(togglePlayback),
            keyEquivalent: ""
        )
        item.target = self
        item.isEnabled = sounds.selected != nil
        menu.addItem(item)
        return menu
    }

    @objc private func togglePlayback() {
        sounds.togglePlayback()
    }
}
