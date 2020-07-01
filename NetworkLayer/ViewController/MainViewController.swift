//
//  MainViewController.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private let mockRepository = MockRepository()
    private var disposal = Disposal()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen

        // MARK: - Networking
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
