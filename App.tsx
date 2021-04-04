import React from "react";
import { SafeAreaView } from "react-native";
import { Root } from "components";
import { DefaultTheme, Provider as PaperProvider } from "react-native-paper";
import { StoreProvider } from "store";

const theme = {
    ...DefaultTheme,
    roundness: 2,
    colors: {
        ...DefaultTheme.colors,
        primary: "#014f86",
    },
};

const App = () => (
    <PaperProvider theme={theme}>
        <StoreProvider>
            <SafeAreaView>
                <Root />
            </SafeAreaView>
        </StoreProvider>
    </PaperProvider>
);

export default App;
