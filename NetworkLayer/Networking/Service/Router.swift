//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/07.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

typealias NetworkResult<T: Decodable> = NetworkObservable<Result<T, Error>>

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request<T: Decodable>(_ route: EndPoint) -> NetworkResult<T>
    func cancel()
}

final class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?

    func request<T: Decodable>(_ route: EndPoint) -> NetworkResult<T> {
        let observable: MutableNetworkObservable<ResultWithError<T>> = .init(.failure(NetworkResponseError.failed))
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request) { data, response, error in
                NetworkLogger.log(response: response)
                observable.wrappedValue = NetworkHelper.shared.handle(data, response, error)
            }
        } catch {
            observable.wrappedValue = .failure(error)
        }
        task?.resume()
        return observable
    }

    func cancel() {
        task?.cancel()
    }
}
