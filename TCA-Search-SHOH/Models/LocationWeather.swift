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
