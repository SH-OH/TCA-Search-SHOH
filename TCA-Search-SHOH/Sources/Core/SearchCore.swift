//
//  SearchCore.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/06.
//

import SwiftUI
import ComposableArchitecture

struct SearchState: Equatable {
    var locations: [Location] = []
    var locationWeather: LocationWeather?
    var locationWeatherRequestInFlight: Location?
    var searchQuery: String = ""
}

enum SearchAction: Equatable {
    case locationResponse(Result<[Location], Failure>)
    case locationTapped(Location)
    case locationWeatherResponse(Result<LocationWeather, Failure>)
    case searchQueryChanged(String)
}

struct SearchEnvironment {
    let useCase: WeatherUseCase
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let searchReducer: Reducer<SearchState, SearchAction, SearchEnvironment> = .init {
    state, action, environment in
    switch action {
    case .locationResponse(.failure):
        state.locations = []
        return .none
        
    case let .locationResponse(.success(response)):
        state.locations = response
        return .none
        
    case let .locationTapped(location):
        struct SearchWeatherId: Hashable {}
        
        state.locationWeatherRequestInFlight = location
        
        return environment.useCase
            .fetchGetWeather(id: location.id)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SearchAction.locationWeatherResponse)
            .cancellable(id: SearchWeatherId(), cancelInFlight: true)
        
    case let .searchQueryChanged(query):
        struct SearchLocationId: Hashable {}
        
        state.searchQuery = query
        
        guard !query.isEmpty else {
            state.locations = []
            state.locationWeather = nil
            return .cancel(id: SearchLocationId())
        }
     
        return environment.useCase
            .fetchGetSearchLocation(query: query)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .debounce(id: SearchLocationId(), for: 0.3, scheduler: environment.mainQueue)
            .map(SearchAction.locationResponse)
        
    case let .locationWeatherResponse(.failure(locationWeather)):
        state.locationWeather = nil
        state.locationWeatherRequestInFlight = nil
        return .none
        
    case let .locationWeatherResponse(.success(locationWeather)):
        state.locationWeather = locationWeather
        state.locationWeatherRequestInFlight = nil
        return .none
    }
}
