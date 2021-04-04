import AsyncStorage from "@react-native-async-storage/async-storage";

export const addFavoriteWord = async (word: string) => {
    const favorites = await getFavoriteWords();

    favorites.push(word);

    await AsyncStorage.setItem("favorites", JSON.stringify(favorites));

    alert("Word favorited!");
};

export const removeFavoriteWord = async (index: number) => {
    const favorites = await getFavoriteWords();

    favorites.splice(index, 1);

    await AsyncStorage.setItem("favorites", JSON.stringify(favorites));

    alert("Word removed!");
};

export const getFavoriteWords = async () =>
    JSON.parse((await AsyncStorage.getItem("favorites")) ?? "[]") as string[];
