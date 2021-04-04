import React from "react";
import { View } from "react-native";
import { Menu, Record, Output } from "components";

export const Root = () => {
    return (
        <View style={{ height: "100%", alignItems: "center" }}>
            <Menu />
            <Output />
            <Record />
        </View>
    );
};
