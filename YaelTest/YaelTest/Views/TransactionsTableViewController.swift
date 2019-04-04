//
//  TransactionsTableViewController.swift
//  YaelTest
//
//  Created by  Mac on 04/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import UIKit

let KRequestedCurrency = "GBP"

class TransactionsTableViewController: UITableViewController {
    
    var sku:String = ""
    var transactions:[String:[Double]]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var sections:Array<String> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = sku
        transactions = TransactionsManager.shared.getDataGroupedByCurrency(sku: sku)
        if let keys = transactions?.keys{
            sections = Array(keys)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions?[sections[section]]?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsAmount", for: indexPath) as! TransactionsAmountTableViewCell
        
        let amount = transactions?[sections[indexPath.section]]?[indexPath.row]
        if sections[indexPath.section] == KRequestedCurrency{
            cell.configureCell(amount: amount ?? 0.0)
        }
            
        else{
            let convertedAmount = RatesManager.shared.convert(amount: amount ?? 0.0, fromCoins: sections[indexPath.section], toCoin: KRequestedCurrency)
            
            // Configure the cell...
            cell.configureCell(amount: convertedAmount)
        }
        
        return cell
    }
}
