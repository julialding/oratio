import { Token } from "models";
import { gemoji } from "gemoji";

const colors = require("assets/colorWords.json");
const sentiment = require("assets/sentimentWords.json");

const knownWords = new Map<string, Token>();

export const analyze = (
    words: string[],
    onUpdate: (tokens: Token[]) => void
) => {
    const newWords = words.filter(
        (word) => !knownWords.has(word.toLowerCase())
    );

    for (const word of newWords) {
        requestToken(word).then(() => onUpdate(getTokens(words)));
    }
};

const requestToken = async (word: string) => {
    const token = parse(word);
    knownWords.set(word.toLowerCase(), token);
};

const parse = (word: string): Token => {
    const color = parseColor(word);
    if (color != null) return color;

    const emoji = parseEmoji(word);
    if (emoji != null) return emoji;

    const sentiment = parseSentiment(word);
    if (sentiment != null) return sentiment;

    return { type: "plain", text: word };
};

const parseColor = (word: string): Token | undefined => {
    const color = colors[word.toLowerCase()];

    return color != null ? { type: "color", text: word, color } : undefined;
};

const parseSentiment = (word: string): Token | undefined => {
    const wordSentiment = sentiment[word.toLowerCase()];

    if (wordSentiment == null) return undefined;

    if (wordSentiment > 7)
        return { type: "sentiment", text: word, color: "green" };
    else if (wordSentiment < 4)
        return { type: "sentiment", text: word, color: "red" };
};

const parseEmoji = (word: string): Token | undefined => {
    if (word.length < 4) return undefined;

    const matchingEmoji = gemoji.filter(
        (e) => e.names.includes(word) || e.tags.includes(word)
    );

    if (matchingEmoji.length === 0) return undefined;

    const { emoji } = matchingEmoji[
        Math.floor(Math.random() * matchingEmoji.length)
    ];

    return {
        type: "emoji",
        text: word,
        emoji,
    };
};

const getTokens = (words: string[]): Token[] =>
    words.map(
        (word) =>
            knownWords.get(word.toLowerCase()) ?? { type: "plain", text: word }
    );
