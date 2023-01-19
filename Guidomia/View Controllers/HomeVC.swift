//
//  HomeVC.swift
//  Guidomia
//
//  Created by Kamal Trapasiya on 2023-01-19.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    private var cancellable: AnyCancellable?
    let carViewModel = CarViewModel()
    var carArr = [Car]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = carViewModel.$carArr.sink(receiveValue: { items in
            self.carArr = items
        })
    }
}
