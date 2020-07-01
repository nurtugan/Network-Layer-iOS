//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Nurtugan Nuraly on 6/29/20.
//  Copyright © 2020 Malcolm Kumwenda. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parametersNil
    case encodingFailed
    case missingURL

    var localizedDescription: String {
        switch self {
        case .parametersNil: return "Parameters were nil."
        case .encodingFailed: return "Parameter encoding failed."
        case .missingURL: return "URL is nil."
        }
    }
}
