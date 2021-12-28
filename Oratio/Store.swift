import SwiftUI

class Store: ObservableObject {
    @Published var languages: [Language]?

    @Published var settings = UserDefaults.standard.decode(Settings.self, forKey: "settings") ?? Settings() {
        didSet {
            UserDefaults.standard.encode(self.settings, forKey: "settings")
        }
    }

    @Published var savedWords = UserDefaults.standard.decode([String: Language.ID].self, forKey: "savedWords") ?? [:] {
        didSet {
            UserDefaults.standard.encode(self.savedWords, forKey: "savedWords")
        }
    }

    @Published var error: Error?
}

extension Store {
    var selectedLanguage: Language? {
        self.languages?
            .first(where: { $0.id == self.settings.selectedLanguage })
            ?? self.languages?.first
    }
}
