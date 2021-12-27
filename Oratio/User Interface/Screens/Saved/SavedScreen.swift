import SwiftUI

struct SavedScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: Store

    @ScaledMetric(relativeTo: .body) var fontSize: CGFloat = 17

    @State private var parentViewController: UIViewController?

    var body: some View {
        NavigationView {
            Group {
                if self.store.savedWords.isEmpty {
                    VStack {
                        Spacer()

                        VStack(spacing: 12) {
                            Image(systemName: "bookmark.fill")
                                .font(.largeTitle)

                            Text("Tap on a word to save it here")
                                .font(.title)
                        }
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()

                        Spacer()
                    }
                } else {
                    Form {
                        if let languages = self.store.languages {
                            let savedWords = self.savedWords(languages: languages)

                            ForEach(savedWords, id: \.0.id) { language, words in
                                Section(header: Text(language.id)) {
                                    ForEach(words, id: \.self) { word in
                                        Button(action: { self.define(word) }) {
                                            WordView(
                                                language: language,
                                                word: NLP.Word(lemma: word, full: word),
                                                overrideFontSize: self.fontSize
                                            )
                                        }
                                    }
                                    .onDelete { indices in
                                        for index in indices {
                                            let word = words[index]
                                            self.store.savedWords[word] = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.dismiss() }) {
                        Text("Done")
                    }
                }
            }
        }
        .introspectViewController { viewController in
            self.parentViewController = viewController
        }
    }

    private func savedWords(languages: [Language]) -> [(Language, [String])] {
        var savedWords: [Language.ID: [String]] = [:]

        for (word, language) in self.store.savedWords {
            savedWords[language, default: []].append(word)
        }

        for key in savedWords.keys {
            savedWords[key]!.sort()
        }

        return savedWords
            .compactMap { languageID, words in
                guard let language = languages.first(where: { $0.id == languageID }) else {
                    return nil
                }

                return (language, words)
            }
            .sorted(using: KeyPathComparator(\.0.id))
    }

    private func define(_ word: String) {
        let referenceLibraryViewController = UIReferenceLibraryViewController(term: word)
        self.parentViewController?.present(referenceLibraryViewController, animated: true)
    }
}
