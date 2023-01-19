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
    let rowHeight = CGFloat(120)
    var carArr = [Car]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = carViewModel.$carArr.sink(receiveValue: { items in
            self.carArr = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateConstraints()
            }
        })
    }
    
    //MARK: Updating tableview height
    func updateConstraints() {
        self.tableViewHeightConstant.constant = rowHeight * CGFloat(carArr.count)
        self.tableView.layoutIfNeeded()
    }
}

//MARK: Tableview delegates
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! TableViewCell
        let car = carArr[indexPath.row]
        cell.carImgView.image = UIImage.init(named: "\(car.make!) \(car.model!)".replacingOccurrences(of: " ", with: "_"))
        cell.carModelLbl.text = "\(car.make!) \(car.model!)"
        let carPrice = Int(car.marketPrice)/1000
        cell.carPriceLbl.text = "Price: \(carPrice)K"
        cell.carRatingView.rating = car.rating
        return cell
    }
}
