//
//  LocationWeather.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/06.
//

import Foundation

struct LocationWeather: Decodable, Equatable {
    let consolidatedWeather: [ConsolidatedWeather]
    let id: Int
    
    struct ConsolidatedWeather: Decodable, Equatable {
        let applicableDate: Date
        let maxTemp: Double
        let minTemp: Double
        let theTemp: Double
        let weatherStateName: String?
    }
}

extension LocationWeather {
    private enum CodingKeys: String, CodingKey {
      case consolidatedWeather = "consolidated_weather"
      case id = "woeid"
    }
}

extension LocationWeather.ConsolidatedWeather {
    private enum CodingKeys: String, CodingKey {
      case applicableDate = "applicable_date"
      case maxTemp = "max_temp"
      case minTemp = "min_temp"
      case theTemp = "the_temp"
      case weatherStateName = "weather_state_name"
    }
}
