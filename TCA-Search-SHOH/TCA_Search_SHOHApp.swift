//
//  TCA_Search_SHOHApp.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/06.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_Search_SHOHApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store(
                initialState: SearchState(),
                reducer: searchReducer.debug(),
                environment: SearchEnvironment()
            )
            SearchView(store: store)
        }
    }
}
