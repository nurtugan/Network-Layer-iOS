//
//  MainViewModel.swift
//  NetworkLayer
//
//  Created by Nurtugan Nuraly on 6/30/20.
//  Copyright © 2020 Malcolm Kumwenda. All rights reserved.
//

import Foundation

final class MainViewModel {
    private let mockRepository = MockRepository()
    private var disposal = Disposal()

    func getBranches() {
        mockRepository.getBranches(partnerID: 1).observe { result, _ in
            switch result {
            case .success(let branches):
                print(branches[1].id)
            case .failure(let error):
                print(error)
            }
        }.add(to: &disposal)
    }
}
