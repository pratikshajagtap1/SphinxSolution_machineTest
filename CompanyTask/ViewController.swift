//
//  ViewController.swift
//  CompanyTask
//
//  Created by Mac on 13/12/1944 Saka.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = "Name : Pratiksha"
        mobileNumberLabel.text = "MobileNumber : 7820838010"
    }


}

