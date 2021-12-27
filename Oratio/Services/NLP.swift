import NaturalLanguage

enum NLP {
    struct Word: Hashable {
        let lemma: String
        let full: String
    }

    static var language = NLLanguage.english // TODO: Choose language

    static func words(in text: String) -> [Word] {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        tagger.setLanguage(self.language, range: text.startIndex..<text.endIndex)

        var words: [Word] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, range in
            let fullWord = String(text[range])

            if !fullWord.contains(where: \.isWhitespace) {
                words.append(Word(lemma: (tag?.rawValue ?? fullWord).lowercased(), full: fullWord))
            }

            return true
        }

        return words
    }
}
