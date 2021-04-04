import React, { useEffect, useRef, useState } from "react";
import { ScrollView, View } from "react-native";
import DeviceInfo from "react-native-device-info";
import { display } from "layers/display";
import { useStore } from "store";
import { Headline } from "react-native-paper";

export const Output = () => {
    const [store, dispatch] = useStore();

    const [fontScale, setFontScale] = useState(0);

    useEffect(() => {
        DeviceInfo.getFontScale().then(setFontScale);
    }, []);

    const scrollView = useRef<ScrollView>();

    return (
        <ScrollView
            style={{ width: "100%" }}
            contentContainerStyle={{ padding: 20 }}
            ref={(ref) => (scrollView.current = ref as any)}
            onContentSizeChange={() =>
                scrollView.current?.scrollToEnd({ animated: true })
            }
        >
            {
                <View style={{ flexDirection: "row", flexWrap: "wrap" }}>
                    {store.tokens.length == 0 && (
                        <Headline style={{ margin: 10, color: "gray" }}>
                            Press Record to start transcribing!
                        </Headline>
                    )}

                    {display(store.tokens, { size: 56 * fontScale })}
                </View>
            }
        </ScrollView>
    );
};
