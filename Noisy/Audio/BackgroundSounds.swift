import Foundation
import Observation
import notify

@Observable
final class BackgroundSounds {
    private(set) var isPlaying = false
    private(set) var selected: BackgroundSound = .balancedNoise
    private(set) var volume: Double = 0.5
    private(set) var timerEnd: Date?

    private let domain = "com.apple.ComfortSounds" as CFString

    init() {
        refresh()
    }

    // MARK: Actions

    func play(_ sound: BackgroundSound) {
        if sound != selected {
            selected = sound
            write("ComfortSoundsSelectedSound", ComfortSoundArchive.encode(sound) as CFData)
        }
        setPlaying(true)
    }

    func togglePlayback() {
        setPlaying(!isPlaying)
    }

    func setVolume(_ volume: Double) {
        self.volume = volume
        write("relativeVolume", volume as CFNumber)
    }

    func startTimer(minutes: Int) {
        let end = Date.now.addingTimeInterval(TimeInterval(minutes * 60))
        timerEnd = end
        write("timerEndInterval", end.timeIntervalSinceReferenceDate as CFNumber)
        write("timerEnabled", kCFBooleanTrue)
        setPlaying(true)
    }

    func cancelTimer() {
        timerEnd = nil
        write("timerEnabled", kCFBooleanFalse)
    }

    func monitor() async {
        while !Task.isCancelled {
            refresh()
            try? await Task.sleep(for: .seconds(1))
        }
    }

    // MARK: Preferences

    private func setPlaying(_ playing: Bool) {
        isPlaying = playing
        write("comfortSoundsEnabled", playing ? kCFBooleanTrue : kCFBooleanFalse)
        if !playing && timerEnd != nil { cancelTimer() }
    }

    private func refresh() {
        CFPreferencesAppSynchronize(domain)
        isPlaying = read("comfortSoundsEnabled") as? Bool ?? false
        volume = read("relativeVolume") as? Double ?? volume
        if let data = read("ComfortSoundsSelectedSound") as? Data, let sound = ComfortSoundArchive.decode(data) {
            selected = sound
        }
        if isPlaying, read("timerEnabled") as? Bool == true, let end = read("timerEndInterval") as? Double,
           end > Date.now.timeIntervalSinceReferenceDate {
            timerEnd = Date(timeIntervalSinceReferenceDate: end)
        } else {
            timerEnd = nil
        }
    }

    private func read(_ key: String) -> Any? {
        CFPreferencesCopyAppValue(key as CFString, domain)
    }

    private func write(_ key: String, _ value: CFPropertyList) {
        CFPreferencesSetAppValue(key as CFString, value, domain)
        CFPreferencesAppSynchronize(domain)
        notify_post("_AXNotification_\(key)")
    }
}

@objc(NoisyComfortSoundArchive)
private nonisolated final class ComfortSoundArchive: NSObject, NSCoding {
    let fileName: String
    let url: URL?
    let group: Int

    init(_ sound: BackgroundSound) {
        fileName = sound.fileName
        url = sound.fileURL
        group = sound.group
    }

    init?(coder: NSCoder) {
        fileName = coder.decodeObject(forKey: "HUComfortSoundNameKey") as? String ?? ""
        url = coder.decodeObject(forKey: "HUComfortSoundPathKey") as? URL
        group = coder.decodeInteger(forKey: "HUComfortSoundGroupKey")
    }

    func encode(with coder: NSCoder) {
        coder.encode(nil as Any?, forKey: "HUComfortSoundAssetKey")
        coder.encode(fileName, forKey: "HUComfortSoundNameKey")
        coder.encode(url, forKey: "HUComfortSoundPathKey")
        coder.encode(group, forKey: "HUComfortSoundGroupKey")
    }

    static func encode(_ sound: BackgroundSound) -> Data {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.setClassName("HUComfortSound", for: ComfortSoundArchive.self)
        archiver.encode(ComfortSoundArchive(sound), forKey: NSKeyedArchiveRootObjectKey)
        guard var plist = try? PropertyListSerialization.propertyList(from: archiver.encodedData, format: nil) as? [String: Any],
              var objects = plist["$objects"] as? [Any],
              let index = objects.lastIndex(where: { ($0 as? [String: Any])?["$classname"] as? String == "HUComfortSound" })
        else { return archiver.encodedData }
        objects[index] = ["$classname": "HUComfortSound", "$classes": ["HUComfortSound", "NSObject"]]
        plist["$objects"] = objects
        return (try? PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: 0)) ?? archiver.encodedData
    }

    static func decode(_ data: Data) -> BackgroundSound? {
        guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else { return nil }
        unarchiver.requiresSecureCoding = false
        unarchiver.setClass(ComfortSoundArchive.self, forClassName: "HUComfortSound")
        let archive = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? ComfortSoundArchive
        return archive.flatMap { BackgroundSound(rawValue: $0.fileName) }
    }
}
