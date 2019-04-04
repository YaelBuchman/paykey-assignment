//
//  MainScreenTableViewCell.swift
//  YaelTest
//
//  Created by  Mac on 04/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import UIKit

class MainScreenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skuLabel: UILabel?
    @IBOutlet weak var transactionsCount: UILabel?
    
    func configureCell(sku:String, count:Int){
        DispatchQueue.main.async {
            self.skuLabel?.text = sku
            self.transactionsCount?.text = String(count)
        }
    }

}
