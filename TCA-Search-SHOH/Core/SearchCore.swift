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
//    case locationResponse(Result<[Location], Weather)
    case locationTapped(Location)
    case searchQueryChanged(String)
}

struct SearchEnvironment {
    
}

let searchReducer: Reducer<SearchState, SearchAction, SearchEnvironment> = .init {
    state, action, environment in
    switch action {
    case let .locationTapped(location):
        struct SearchWeatherId: Hashable {}
        
        state.locationWeatherRequestInFlight = location
        
        return .none
    case let .searchQueryChanged(query):
        struct SearchLocationId: Hashable {}
        
        state.searchQuery = query
        
        guard !query.isEmpty else {
            state.locations = []
            state.locationWeather = nil
            return .cancel(id: SearchLocationId())
        }
     
        return .none
            
    }
}
