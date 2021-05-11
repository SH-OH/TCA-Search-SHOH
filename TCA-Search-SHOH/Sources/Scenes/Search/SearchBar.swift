//
//  SearchBar.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/11.
//

import SwiftUI
import ComposableArchitecture

struct SearchBar: View {
    let placehold: String
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    placehold,
                    text: viewStore.binding(
                        get: { $0.searchQuery },
                        send: SearchAction.searchQueryChanged
                    )
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }
            .padding([.leading, .trailing], 16)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                useCase: WeatherUseCase(),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
        SearchBar(
            placehold: "test placehold",
            store: store
        )
    }
}
