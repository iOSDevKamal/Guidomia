//
//  HomeVC.swift
//  Guidomia
//
//  Created by Kamal Trapasiya on 2023-01-19.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    
    private var cancellable: AnyCancellable?
    let carViewModel = CarViewModel()
    var carArr = [Car]()
    var expandedCellIndex = 0
    var makeStr = "" {
        didSet {
            self.carViewModel.filterCars(make: makeStr, model: modelStr)
        }
    }
    var modelStr = "" {
        didSet {
            self.carViewModel.filterCars(make: makeStr, model: modelStr)
        }
    }
    
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
    
    //MARK: Filter cars by make
    @IBAction func makeSelection(_ sender: UIButton) {
        let result = carViewModel.getData()
        let makeArr = ["Any make"] + result.map { $0.make! }
        self.dropDownMenu(sender: sender, options: makeArr) { makeIndex in
            self.expandedCellIndex = 0
            let value = makeArr[makeIndex]
            sender.setTitle(value, for: .normal)
            self.makeStr = makeIndex == 0 ? "" : value
        }
    }
    
    //MARK: Filter cars by model
    @IBAction func modelSelection(_ sender: UIButton) {
        let result = carViewModel.getData()
        let modelArr = ["Any model"] + result.map { $0.model! }
        self.dropDownMenu(sender: sender, options: modelArr) { modelIndex in
            self.expandedCellIndex = 0
            let value = modelArr[modelIndex]
            sender.setTitle(value, for: .normal)
            self.modelStr = modelIndex == 0 ? "" : value
        }
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
        
        cell.detailsViewHeightConstant.constant = expandedCellIndex == indexPath.row ? 100 + prosHeight + consHeight : 0
        cell.dividerView.isHidden = indexPath.row == carArr.count - 1 ? true : false
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

