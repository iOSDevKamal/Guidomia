//
//  TableViewCell.swift
//  Guidomia
//
//  Created by Kamal Trapasiya on 2023-01-19.
//

import UIKit
import Cosmos

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var carModelLbl: UILabel!
    @IBOutlet weak var carPriceLbl: UILabel!
    @IBOutlet weak var carRatingView: CosmosView!
    
    @IBOutlet weak var prosLbl: UILabel!
    @IBOutlet weak var consLbl: UILabel!
    @IBOutlet weak var detailsViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var dividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
