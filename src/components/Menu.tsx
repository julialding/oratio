import React from "react";
import { Image, View } from "react-native";
import { Appbar } from "react-native-paper";

export const Menu = () => (
    <Appbar>
        <Appbar.Content
            title={
                <View
                    style={{
                        flexDirection: "row",
                        alignItems: "center",
                    }}
                >
                    <Image
                        source={require("../../assets/logo.png")}
                        resizeMode="contain"
                        style={{
                            width: 90,
                            height: 70,
                            marginTop: 6,
                            marginRight: 10,
                        }}
                    />
                </View>
            }
        />

        <Appbar.Action icon="star" onPress={() => alert("Work in progress!")} />

        <Appbar.Action
            icon="bookmark"
            onPress={() => alert("Work in progress!")}
        />
    </Appbar>
);
