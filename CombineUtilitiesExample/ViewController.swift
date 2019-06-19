//
//  ViewController.swift
//  CombineUtilitiesExample
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import UIKit
import Combine
import CombineUtilities

class ViewController: UIViewController {

    @IBOutlet private weak var button: UIButton!
    private var bag = CancellableBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let imageUrl = "https://www.123freevectors.com/wp-content/original/146083-dark-blue-blurred-bokeh-background-image.jpg"
        button.publisher(for: .touchUpInside)
            .map { _ in URLSession.shared.dataTaskPublisher(for: URL(string: imageUrl)!) }
            .switchToLatest()
            .sink { (data: Data, response: URLResponse) in
                print("data size: \(data.count)")
        }.cancelled(by: bag)
    }
}
