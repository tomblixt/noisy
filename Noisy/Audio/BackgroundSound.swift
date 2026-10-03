import Foundation

nonisolated enum BackgroundSound: String, CaseIterable, Identifiable {
    case balancedNoise = "PinkNoise"
    case brightNoise = "WhiteNoise"
    case darkNoise = "BrownNoise"
    case ocean = "Ocean"
    case rain = "Rain"
    case stream = "Stream"
    case night = "Night"
    case fire = "Fire"
    case babble = "Babble"
    case steam = "Steam"
    case aeroplane = "Airplane"
    case boat = "Boat"
    case bus = "Bus"
    case train = "Train"
    case rainOnRoof = "RainOnRoof"
    case quietNight = "QuietNight"

    var id: String { rawValue }

    var fileName: String { rawValue }

    var group: Int { Self.allCases.firstIndex(of: self)! + 1 }

    var fileURL: URL {
        URL(filePath: "/System/Library/PrivateFrameworks/HearingUtilities.framework/Resources/\(fileName).m4a")
    }

    var title: String {
        SystemSoundNames.name(for: fileName) ?? englishTitle
    }

    private var englishTitle: String {
        switch self {
        case .balancedNoise: "Balanced Noise"
        case .brightNoise: "Bright Noise"
        case .darkNoise: "Dark Noise"
        case .ocean: "Ocean"
        case .rain: "Rain"
        case .stream: "Stream"
        case .night: "Night"
        case .fire: "Fire"
        case .babble: "Babble"
        case .steam: "Steam"
        case .aeroplane: "Aeroplane"
        case .boat: "Boat"
        case .bus: "Bus"
        case .train: "Train"
        case .rainOnRoof: "Rain On Roof"
        case .quietNight: "Quiet Night"
        }
    }

    var symbol: String {
        switch self {
        case .balancedNoise, .brightNoise, .darkNoise: "waveform"
        case .ocean: "water.waves"
        case .rain: "cloud.rain"
        case .stream: "drop"
        case .night: "moon.stars"
        case .fire: "flame"
        case .babble: "person.2.wave.2"
        case .steam: "humidity"
        case .aeroplane: "airplane"
        case .boat: "ferry"
        case .bus: "bus"
        case .train: "train.side.front.car"
        case .rainOnRoof: "house"
        case .quietNight: "moon.zzz"
        }
    }
}

private nonisolated enum SystemSoundNames {
    private static let names: [String: String] = {
        let url = URL(filePath: "/System/Library/PrivateFrameworks/HearingUtilities.framework/Resources/HearingAidSupport.loctable")
        guard let data = try? Data(contentsOf: url),
              let table = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        else { return [:] }

        let appLanguage = Bundle.main.preferredLocalizations.first ?? "en"
        let appLanguageCode = Locale(identifier: appLanguage).language.languageCode
        let preferences = Locale.preferredLanguages.filter { Locale(identifier: $0).language.languageCode == appLanguageCode }
            + [appLanguage]
        guard let best = Bundle.preferredLocalizations(from: Array(table.keys), forPreferences: preferences).first else { return [:] }

        let base = Locale(identifier: best).language.languageCode?.identifier ?? best
        var names = table[base] as? [String: String] ?? [:]
        names.merge(table[best] as? [String: String] ?? [:]) { _, regional in regional }
        return names
    }()

    static func name(for fileName: String) -> String? {
        names["ComfortSound_\(fileName)"]
    }
}
