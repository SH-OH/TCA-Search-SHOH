//
//  BaseProviderProtocol.swift
//  TCA-Search-SHOH
//
//  Created by Oh Sangho on 2021/05/07.
//

import Foundation
import Moya
import CombineMoya
import ComposableArchitecture

struct Failure: Error, Equatable {}

protocol BaseProviderProtocol {
    associatedtype Target: TargetType
    
    var provider: MoyaProvider<Target> { get }
    
    init(isStub: Bool)
}

extension BaseProviderProtocol {
    private var queue: DispatchQueue {
        DispatchQueue(
            label: "BaseProvider.Queue",
            qos: .background
        )
    }
    private var jsonDecoder: JSONDecoder {
      let d = JSONDecoder()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      d.dateDecodingStrategy = .formatted(formatter)
      return d
    }
    
    static func initProvider(
        _ isStub: Bool
    ) -> MoyaProvider<Target> {
        if !isStub {
            return MoyaProvider<Target>()
        } else {
            return MoyaProvider<Target>(
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
    
    func request<T: Decodable>(
        _ modelType: T.Type,
        target: Target
    ) -> Effect<T, Failure> {
        return provider
            .requestPublisher(target)
            .handleEvents(receiveOutput: { self.printDebug(target: target, response: $0) })
            .eraseToAnyPublisher()
            .map(modelType.self, using: jsonDecoder)
            .mapError { error in
                print(error)
                return Failure()
            }
            .eraseToEffect()
    }
    
    private func printDebug(
        target: Target,
        response: Response
    ) {
        let debug: String = """
            01.URL: [\(target.method.rawValue)] \(target.baseURL)\(target.path),
            02.Target: \(target),
            03.Response: \(String(data: response.data, encoding: .utf8) ?? "NO DATA")
        """
        print(debug)
    }
}
