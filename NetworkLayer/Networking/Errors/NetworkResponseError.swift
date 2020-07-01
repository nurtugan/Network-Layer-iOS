//
//  NetworkResponseError.swift
//  NetworkLayer
//
//  Created by Nurtugan Nuraly on 6/29/20.
//  Copyright © 2020 Malcolm Kumwenda. All rights reserved.
//

import Foundation

enum NetworkResponseError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case httpURLResponseCastFailed
    
    var localizedDescription: String {
        switch self {
        case .authenticationError: return "You need to be authenticated first."
        case .badRequest: return "Bad request."
        case .outdated: return "The url you requested is outdated."
        case .failed: return "Network request failed."
        case .noData: return "Response returned with no data to decode."
        case .unableToDecode: return "We could not decode the response."
        case .httpURLResponseCastFailed: return "HTTP url response cast failed."
        }
    }
}
