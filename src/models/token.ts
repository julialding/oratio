export type Token =
    | { type: "plain"; text: string }
    | { type: "sentiment"; text: string; color: "red" | "green" }
    | { type: "color"; text: string; color: string }
    | { type: "emoji"; text: string; emoji: string };
