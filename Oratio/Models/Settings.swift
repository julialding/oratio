import Foundation

struct Settings: Codable {
    var selectedLanguage: Language.ID?
    var fontSize = 28.0
    var defaultFont: String?
}
