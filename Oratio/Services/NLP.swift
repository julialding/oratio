import NaturalLanguage

enum NLP {
    struct Word: Hashable {
        let lemma: String
        let full: String
    }

    static func words(in text: String, language: NLLanguage) -> [Word] {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        tagger.setLanguage(language, range: text.startIndex..<text.endIndex)

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
    
    static let similarWordDistanceThreshold = 0.95
    
    static func similarWords(for word: String, language: NLLanguage) -> [(word: String, score: Double)] {
        guard let embedding = NLEmbedding.wordEmbedding(for: language) else {
            return []
        }
        
        return embedding
            .neighbors(for: word, maximumCount: 10)
            .filter { $0.1 < Self.similarWordDistanceThreshold }
            .sorted(using: KeyPathComparator(\.1))
    }
}
