module.exports = {
    presets: ["module:metro-react-native-babel-preset"],
    plugins: [
        [
            "module-resolver",
            {
                alias: {
                    assets: "./assets",
                    components: "./src/components",
                    config: "./config",
                    layers: "./src/layers",
                    models: "./src/models",
                    store: "./src/store",
                },
            },
        ],
    ],
};
