//
//  MockRepository.swift
//  NetworkLayer
//
//  Created by Nurtugan Nuraly on 6/29/20.
//  Copyright © 2020 Malcolm Kumwenda. All rights reserved.
//

import Foundation

protocol MockRepositoryProtocol {
    func getBranch(branchID: Int) -> NetworkObservable<MockModel>
    func getBranches(partnerID: Int) -> NetworkObservable<[MockModel]>
}

final class MockRepository: MockRepositoryProtocol {
    private let router = Router<MockAPI>()

    func getBranch(branchID: Int) -> NetworkObservable<MockModel> {
        router.request(.getBranch(branchID: branchID))
    }

    func getBranches(partnerID: Int) -> NetworkObservable<[MockModel]> {
        router.request(.getBranches(partnerID: partnerID))
    }
}
