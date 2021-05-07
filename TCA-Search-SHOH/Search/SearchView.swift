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
        static let readMe = """
  This application demonstrates live-searching with the Composable Architecture. As you type the \
  events are debounced for 300ms, and when you stop typing an API request is made to load \
  locations. Then tapping on a location will load weather.
  """
        static let placehold = "New York, San Francisco, ..."
    }
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading, content: {
                    Text(Constants.readMe)
                        .padding()
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField(
                            Constants.placehold,
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
                    
                    List {
                        ForEach(viewStore.locations) { location in
                            VStack(alignment: .leading, content: {
                                Button(action: { viewStore.send(.locationTapped(location))}, label: {
                                    HStack {
                                        Text(location.title)
                                        
                                        if viewStore.locationWeatherRequestInFlight?.id == location.id {
                                            ActivityIndicator()
                                        }
                                    }
                                })
                                
                                if location.id == viewStore.locationWeather.id {
                                    
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    struct WeartherView: View {
        let locationWeather: LocationWeather?
        
        var body: some View {
            guard let locationWeather = locationWeather else {
                return AnyView(EmptyView())
            }
            
        }
        
        
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment()
        )
        SearchView(store: store)
    }
}
