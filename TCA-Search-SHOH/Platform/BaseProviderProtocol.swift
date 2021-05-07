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
            .map(modelType.self)
            .mapError { _ in Failure() }
            .eraseToEffect()
    }
}
