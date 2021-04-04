import { startListening, stopListening } from "layers";
import { analyze } from "layers/analysis";
import React from "react";
import { IconButton, useTheme } from "react-native-paper";
import { handleError, setTokens, toggleRecord, useStore } from "store";

export const Record = () => {
    const theme = useTheme();
    const [store, dispatch] = useStore();

    const start = () => {
        startListening(handleNewSpeech).catch((error) =>
            dispatch(handleError(error))
        );
    };

    const stop = () => {
        stopListening().catch((error) => dispatch(handleError(error)));
    };

    const handleNewSpeech = (words: string[]) =>
        analyze(words, (tokens) => dispatch(setTokens(tokens)));

    return (
        <IconButton
            icon={store.recording ? "stop" : "microphone"}
            size={45}
            color="white"
            underlayColor={theme.colors.primary}
            style={{ margin: 20, backgroundColor: theme.colors.primary }}
            onPress={() => {
                dispatch(toggleRecord());

                if (store.recording) {
                    stop();
                } else {
                    start();
                }
            }}
        />
    );
};
