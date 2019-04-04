//
//  ViewController.swift
//  YaelTest
//
//  Created by  Mac on 03/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    
    var transactions:[[String:Int]]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        transactions = TransactionsManager.shared.getDataGroupedByTransactionsNumber()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if transactions?.count == 0{
            let alert = UIAlertController(title: "Error", message: "No SKU found", preferredStyle: .alert)
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainScreenTableViewCell
        
        // Configure the cell...
        cell.configureCell(sku: (transactions?[indexPath.row].first?.key) ?? "N/A", count: (transactions?[indexPath.row].first?.value ?? -1))
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController:TransactionsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionsTableViewController") as! TransactionsTableViewController
        
        viewController.sku = (transactions?[indexPath.row].first?.key) ?? "N/A"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

