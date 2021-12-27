import SwiftUI
import Introspect
import StatusAlert

struct RecordingView: View {
    @EnvironmentObject var store: Store

    let language: Language
    let recording: [NLP.Word]
    let onChangeHeight: () -> Void

    @State private var parentViewController: UIViewController?

    var body: some View {
        FlowView(data: Array(self.recording.enumerated()), id: \.offset, onChangeHeight: self.onChangeHeight) { _, word in
            Menu {
                Button(action: { self.toggleSaved(word.lemma) }) {
                    let isSaved = self.isSaved(word.lemma)

                    Label(isSaved ? "Remove" : "Save", systemImage: isSaved ? "bookmark.slash" : "bookmark")
                }

                Button(action: { self.define(word.lemma) }) {
                    Label("Define", systemImage: "character.book.closed")
                }
            } label: {
                WordView(language: self.language, word: word)
            }
        }
        .id(self.recording)
        .id(self.store.settings.defaultFont)
        .id(self.store.settings.fontSize)
        .introspectViewController { viewController in
            self.parentViewController = viewController
        }
    }

    private func define(_ word: String) {
        let referenceLibraryViewController = UIReferenceLibraryViewController(term: word)
        self.parentViewController?.present(referenceLibraryViewController, animated: true)
    }

    private func isSaved(_ word: String) -> Bool {
        self.store.savedWords.keys.contains(word)
    }

    private func toggleSaved(_ word: String) {
        let isSaved = self.isSaved(word)

        self.store.savedWords[word] = isSaved ? nil : self.language.id

        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(systemName: isSaved ? "bookmark.slash.fill" : "bookmark.fill")
        statusAlert.title = isSaved ? "Removed" : "Saved"
        statusAlert.showInKeyWindow()
    }
}
