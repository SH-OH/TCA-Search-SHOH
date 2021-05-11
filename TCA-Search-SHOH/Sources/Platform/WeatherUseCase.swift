//
//  WeatherUseCase.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/07.
//

import Moya
import ComposableArchitecture

struct WeatherUseCase: BaseProviderProtocol {
    var provider: MoyaProvider<WeatherService>
    
    init(isStub: Bool = false) {
        self.provider = Self.initProvider(isStub)
    }
    
    func fetchGetSearchLocation(query: String)
    -> Effect<[Location], Failure> {
        request(
            [Location].self,
            target: .getSearchLocation(query: query)
        )
    }
    
    func fetchGetWeather(id: Int)
    -> Effect<LocationWeather, Failure> {
        request(
            LocationWeather.self,
            target: .getWeather(id: id)
        )
    }
}
