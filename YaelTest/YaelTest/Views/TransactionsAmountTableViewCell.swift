//
//  TransactionsAmountTableViewCell.swift
//  YaelTest
//
//  Created by  Mac on 04/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import UIKit

class TransactionsAmountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionsAmount: UILabel?
    
    func configureCell(amount:Double){
        DispatchQueue.main.async {
            if amount <= 0{
                self.transactionsAmount?.text = "Cannot been converted"
            }
            else{
                self.transactionsAmount?.text = String(amount)
            }
        }
    }
    
}
