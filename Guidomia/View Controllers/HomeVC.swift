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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    
    var expandedCellIndex = 0
    
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
    
    override func viewWillLayoutSubviews() {
        self.updateConstraints()
    }
    
    //MARK: Updating tableview height
    func updateConstraints() {
        self.tableView.layoutIfNeeded()
        self.tableViewHeightConstant.constant = tableView.contentSize.height
    }
}

//MARK: Tableview delegates
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carArr.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! TableViewCell
        let car = carArr[indexPath.row]
        cell.carImgView.image = UIImage.init(named: "\(car.make!) \(car.model!)".replacingOccurrences(of: " ", with: "_"))
        cell.carModelLbl.text = "\(car.make!) \(car.model!)"
        let carPrice = Int(car.marketPrice)/1000
        cell.carPriceLbl.text = "Price: \(carPrice)K"
        cell.carRatingView.rating = car.rating
        
        let prosArr = car.prosList as! NSArray
        let prosStr = prosArr.convertArrToString()
        cell.prosLbl.attributedText = prosStr.string.count > 0 ? prosStr : NSMutableAttributedString.init(string: "-")
        let prosHeight = prosStr.string.height(withConstrainedWidth: self.view.frame.width - 32, font: UIFont.systemFont(ofSize: 15))
        
        let consArr = car.consList as! NSArray
        let consStr = consArr.convertArrToString()
        cell.consLbl.attributedText = consStr.string.count > 0 ? consStr : NSMutableAttributedString.init(string: "-")
        let consHeight = consStr.string.height(withConstrainedWidth: self.view.frame.width - 32, font: UIFont.systemFont(ofSize: 15))
        
        if expandedCellIndex == indexPath.row {
            cell.detailsViewHeightConstant.constant = 100 + prosHeight + consHeight
        }
        else {
            cell.detailsViewHeightConstant.constant = 0
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempIndex = expandedCellIndex
        expandedCellIndex = indexPath.row
        self.tableView.reloadRows(at: [indexPath, IndexPath.init(row: tempIndex, section: 0)], with: .automatic)
        DispatchQueue.main.async {
            self.updateConstraints()
        }
    }
}

