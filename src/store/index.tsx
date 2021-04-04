import React, { createContext, Dispatch, useContext, useReducer } from "react";
import { Store, initialStore } from "./store";

export * from "./store";

export const StoreContext = createContext<
    [Store, Dispatch<(store: Store) => Store>]
>(undefined as any);

const reducer = (store: Store, action: (store: Store) => Store) =>
    action(store);

export const StoreProvider: React.FC = ({ children }) => {
    const [store, dispatch] = useReducer(reducer, initialStore);

    return (
        <StoreContext.Provider value={[store, dispatch]} children={children} />
    );
};

export const useStore = () => useContext(StoreContext);
