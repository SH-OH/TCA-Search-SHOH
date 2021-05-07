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
                                
                                if location.id == viewStore.locationWeather?.id {
                                    if let locationWeather = viewStore.locationWeather {
                                        WeatherView(locationWeather: locationWeather)
                                    } else {
                                        AnyView(EmptyView())
                                    }
                                }
                            })
                        }
                    }
                    
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
    
    struct WeatherView: View {
        let locationWeather: LocationWeather
        var days: [String] {
            locationWeather.consolidatedWeather
                .enumerated()
                .map { idx, weather in formattedWeatherDay(weather, isToday: idx == 0) }
        }
        
        var body: some View {
            VStack(alignment: .leading, content: {
                List(days, id: \.self) { day in
                    Text(day)
                }
            })
            .padding(.leading, 16)
        }
        
        private func formattedWeatherDay(
            _ data: LocationWeather.ConsolidatedWeather,
            isToday: Bool
        ) -> String {
            let dateFormatter: DateFormatter = .init()
            dateFormatter.dateFormat = "EEEE"
            let date = isToday
                ? "Today"
                : dateFormatter.string(from: data.applicableDate).capitalized
            
            return [
                date,
                "\(Int(round(data.theTemp)))",
                data.weatherStateName
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                useCase: WeatherUseCase(isStub: true),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
        SearchView(store: store)
    }
}
