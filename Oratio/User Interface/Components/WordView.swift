import SwiftUI

struct WordView: View {
    @EnvironmentObject var store: Store

    let language: Language
    let word: NLP.Word
    var overrideFontSize: CGFloat? = nil

    var body: some View {
        let style = language.words[self.word.lemma]

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
