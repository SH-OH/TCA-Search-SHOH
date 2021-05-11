//
//  WeatherService.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/07.
//

import Moya
import Foundation

enum WeatherService {
    case getSearchLocation(
            query: String
         )
    case getWeather(
            id: Int
         )
}

extension WeatherService: BaseService, TargetType {
    var path: String {
        switch self {
        case .getSearchLocation:
            return "/api/location/search"
        case let .getWeather(id):
            return "/api/location/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchLocation,
             .getWeather:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getSearchLocation:
            return Self.getSampleData("GetSearchLocation")
        case .getWeather:
            return Self.getSampleData("GetWeather")
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case let .getSearchLocation(query):
            params["query"] = query
        case .getWeather:
            return .requestPlain
        }
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.default
        )
    }
    
    var headers: [String : String]? {
        nil
    }
}
