import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        Group {
            if let languages = self.store.languages {
                let language = languages
                    .first(where: { $0.id == self.store.settings.selectedLanguage })
                    ?? languages.first!

                RecordScreen(language: language)
            }
        }
        .task {
            let languages = await loadLanguages()

            self.store.languages = languages
            self.store.settings.selectedLanguage ??= languages.first!.id
        }
    }
}
