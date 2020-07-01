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

    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionalHeaders):
                addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
