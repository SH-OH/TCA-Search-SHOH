//
//  SearchList.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/11.
//

import SwiftUI
import ComposableArchitecture

struct SearchList: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
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
                            self.weatherView(locationWeather: viewStore.locationWeather)
                        }
                    })
                }
            }
        }
    }
    
    private func weatherView(locationWeather: LocationWeather?) -> some View {
        guard let locationWeather = locationWeather else {
            return AnyView(EmptyView())
        }

        let days = locationWeather.consolidatedWeather
            .enumerated()
            .map { idx, weather in formattedWeatherDay(weather, isToday: idx == 0) }

        return AnyView(
            VStack(alignment: .leading) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                }
            }
            .padding([.leading], 16)
        )
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

struct SearchList_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                useCase: WeatherUseCase(),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
        SearchList(store: store)
    }
}
