//
//  Location.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/06.
//

import Foundation

struct Location: Decodable, Equatable, Identifiable {
    let id: Int
    let title: String
}

extension Location {
    private enum CodingKeys: String, CodingKey {
      case id = "woeid"
      case title
    }
}
