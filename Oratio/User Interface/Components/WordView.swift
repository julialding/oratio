import SwiftUI

struct WordView: View {
    @EnvironmentObject var store: Store

    let language: Language
    let word: NLP.Word
    var overrideFontSize: CGFloat? = nil

    var body: some View {
        let selectedLanguage = self.store.selectedLanguage!
        
        let style: Language.Word? = {
            for (word, _) in CollectionOfOne((self.word.lemma, 1)) + NLP.similarWords(for: self.word.lemma, language: .init(rawValue: selectedLanguage.id)) {
                if let style = language.words[word] {
                    return style
                }
            }
            
            return nil
        }()

        HStack {
            Text(word.full)

            if let emoji = style?.emoji {
                Text(emoji)
            }
        }
        .foregroundColor(style?.color ?? .primary)
        .font(
            ((style?.font).map { Font.custom($0, size: self.fontSize) }
             ?? (self.store.settings.defaultFont).map { Font.custom($0, size: self.fontSize) }
             ?? .system(size: self.fontSize))
                .weight(.medium)
        )
    }

    var fontSize: CGFloat {
        self.overrideFontSize ?? self.store.settings.fontSize
    }
}
