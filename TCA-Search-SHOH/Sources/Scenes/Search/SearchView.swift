//
//  SearchView.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/06.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    private struct Constants {
        static let navigationTitle = "Search"
        static let readMe = """
  This application demonstrates live-searching with the Composable Architecture. As you type the \
  events are debounced for 300ms, and when you stop typing an API request is made to load \
  locations. Then tapping on a location will load weather.
  """
        static let placehold = "New York, San Francisco, ..."
        static let apiProvided = "Weather API provided by MetaWeather.com"
        static let apiUrl = "http://www.MetaWeather.com"
    }
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, content: {
                Text(Constants.readMe)
                    .padding()
                
                SearchBar(
                    placehold: Constants.placehold,
                    store: store
                )
                
                SearchList(store: store)
                
                Button(Constants.apiProvided) {
                    UIApplication.shared.open(URL(string: Constants.apiUrl)!)
                }
                .foregroundColor(.gray)
                .padding(.all, 16)
            })
            .navigationTitle(Constants.navigationTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                useCase: WeatherUseCase(),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
        SearchView(store: store)
    }
}
