import Voice from "@react-native-voice/voice";
import Permissions, { PERMISSIONS } from "react-native-permissions";

export const startListening = async (
    onNewSpeech: (words: string[]) => void
) => {
    const granted = await requestPermissions();

    if (!granted) {
        throw new Error("Permissions denied");
    }

    return await new Promise<void>((resolve, reject) => {
        let isResolved = false;

        Voice.onSpeechStart = () => resolve();

        Voice.onSpeechError = (event) => {
            const handle = isResolved ? console.error : reject;

            handle(new Error(`Error transcribing speech: ${event.error}`));
        };

        Voice.onSpeechPartialResults = Voice.onSpeechResults = (event) => {
            const words = (event.value ?? [])
                .map((words) => words.split(" "))
                .flat();

            onNewSpeech(words);
        };

        Voice.start("en-US");
    });
};

export const stopListening = async () => {
    await Voice.stop();
};

const requestPermissions = async () => {
    const response = await Permissions.requestMultiple([
        PERMISSIONS.IOS.MICROPHONE,
        PERMISSIONS.IOS.SPEECH_RECOGNITION,
        PERMISSIONS.ANDROID.RECORD_AUDIO,
    ]);

    return Object.values(response).every((status) => status === "granted");
};
