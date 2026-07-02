import SwiftUI

// MARK: - App Language

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case uk, en
    var id: String { rawValue }
    /// Language name written in that language.
    var nativeName: String {
        switch self {
        case .uk: return "Українська"
        case .en: return "English"
        }
    }
    var flag: String {
        switch self {
        case .uk: return "🇺🇦"
        case .en: return "🇬🇧"
        }
    }
    /// Locale used for date and number formatting.
    var locale: Locale {
        Locale(identifier: self == .en ? "en_US" : "uk_UA")
    }
}

// MARK: - Appearance Theme

enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case system, light, dark
    var id: String { rawValue }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    var titleKey: String {
        switch self {
        case .system: return "settings.theme.system"
        case .light: return "settings.theme.light"
        case .dark: return "settings.theme.dark"
        }
    }
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

// MARK: - Settings Manager

/// Singleton used so models can read the selected language from computed titles.
/// Updates to `language` and `theme` publish changes to observing views.
final class Settings: ObservableObject {
    static let shared = Settings()

    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "app.language") }
    }
    @Published var theme: AppTheme {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: "app.theme") }
    }

    private init() {
        let defaults = UserDefaults.standard
        if let raw = defaults.string(forKey: "app.language"), let lang = AppLanguage(rawValue: raw) {
            language = lang
        } else {
            // On first launch, use the system language when it is Ukrainian.
            let sys = Locale.preferredLanguages.first ?? "en"
            language = sys.hasPrefix("uk") ? .uk : .en
        }
        if let raw = defaults.string(forKey: "app.theme"), let theme = AppTheme(rawValue: raw) {
            self.theme = theme
        } else {
            self.theme = .system
        }
    }

    func string(_ key: String) -> String {
        Strings.table[key]?[language] ?? Strings.table[key]?[.uk] ?? key
    }
}

/// Short global translation helper used by views and models.
func L(_ key: String) -> String {
    Settings.shared.string(key)
}

/// Translation helper with String(format:) interpolation.
func L(_ key: String, _ args: CVarArg...) -> String {
    String(format: Settings.shared.string(key), arguments: args)
}
