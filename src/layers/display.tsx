import React from "react";
import { Token } from "models";
import { Headline } from "react-native-paper";
import { StyleSheet, TouchableOpacity, View } from "react-native";
import { addFavoriteWord } from "./favorite";
// @ts-ignore
import { contrastColor } from "contrast-color";

export const display = (tokens: Token[], options: { size: number }) =>
    tokens.map((token, index) => {
        const component = (() => {
            switch (token.type) {
                case "plain":
                    return (
                        <Headline style={styles.token}>{token.text}</Headline>
                    );
                case "color":
                    return (
                        <Headline
                            style={[
                                styles.token,
                                {
                                    backgroundColor: token.color,
                                    color: contrastColor({
                                        bgColor: token.color,
                                    }),
                                },
                            ]}
                        >
                            {token.text}
                        </Headline>
                    );
                case "emoji":
                    return (
                        <Headline style={styles.token}>
                            {token.text}
                            {token.emoji}
                        </Headline>
                    );
                case "sentiment":
                    return (
                        <Headline
                            style={[styles.token, { color: token.color }]}
                        >
                            {token.text}
                        </Headline>
                    );
            }
        })();

        return (
            <View
                key={index}
                style={{ height: options.size, justifyContent: "center" }}
            >
                <TouchableOpacity
                    onPress={() => addFavoriteWord(token.text.toLowerCase())}
                >
                    {component}
                </TouchableOpacity>
            </View>
        );
    });

const styles = StyleSheet.create({
    token: {
        margin: 5,
    },
});
