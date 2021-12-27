import SwiftUI

struct Language: Codable, Identifiable {
    let name: String
    let id: String
    let words: [String: Word]

    struct Word: Codable {
        let color: Color?
        let emoji: String?
        let font: String?
    }
}

func loadLanguages() async -> [Language] {
    await Task(priority: .background) {
        let file = Bundle.main.url(forResource: "Languages", withExtension: "json")!
        return try! JSONDecoder().decode([Language].self, from: Data(contentsOf: file))
    }
    .value
}
