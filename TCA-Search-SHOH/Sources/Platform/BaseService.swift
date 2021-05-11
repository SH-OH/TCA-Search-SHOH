//
//  BaseService.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/07.
//

import Foundation

protocol BaseService {}

extension BaseService {
    private var baseURLString: String {
        return "https://www.metaweather.com"
    }
}

extension BaseService {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    static func getSampleData(_ resource: String) -> Data {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            return Data()
        }
        return (try? Data(contentsOf: url)) ?? Data()
    }
}
