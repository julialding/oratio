import { Token } from "models";

export type Store = typeof initialStore;

export const initialStore = {
    tokens: [] as Token[],
    recording: false,
    error: undefined as Error | undefined,
};

export const setTokens = (tokens: Token[]) => (store: Store) => ({
    ...store,
    tokens,
});

export const toggleRecord = () => (store: Store) => ({
    ...store,
    recording: !store.recording,
});

export const handleError = (error: Error) => (store: Store) => {
    console.error(error);

    return {
        ...store,
        error,
    };
};

export const clearError = () => (store: Store) => ({
    ...store,
    error: undefined,
});

/*


handler[word_] := word

CloudDeploy[ APIFunction[{"word" -> "String"}, #ExportString[handler[word], "JSON", "Compact" -> True] &,
  "String"], Permissions -> "Public"]









*/
