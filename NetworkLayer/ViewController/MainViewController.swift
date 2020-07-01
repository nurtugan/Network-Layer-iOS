//
//  MainViewController.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        viewModel = MainViewModel()
        viewModel.getBranches()
    }
}
