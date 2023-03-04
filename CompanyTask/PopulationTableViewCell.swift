//
//  PopulationTableViewCell.swift
//  CompanyTask
//
//  Created by Mac on 13/12/1944 Saka.
//

import UIKit

class PopulationTableViewCell: UITableViewCell {
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
