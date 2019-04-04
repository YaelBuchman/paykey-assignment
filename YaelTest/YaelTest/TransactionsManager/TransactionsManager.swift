//
//  TransactionsManager.swift
//  YaelTest
//
//  Created by  Mac on 03/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import Foundation
class TransactionsManager{
    // MARK: - Properties
    
    //singletone
    static let shared = TransactionsManager()
    /*
     ratesDictionary should set with:
     key = "sku" value
     value = dictionary of transactions
     
     Dictionary that contains:
     key = "currency"
     value: array of amounts
     */
    var transactionsDictionary:[String:[String:[Double]]]
    
    //MARK: - Private Functions
    
    private init(){
        //read rates from file
        transactionsDictionary = [String:[String:[Double]]]()
        updateTransactionsFromFile()
    }
    
    private func updateTransactionsFromFile(){
        let url = Bundle.main.url(forResource: transactionsFile, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            
            //parser it to ratesDictionary
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            for item in json{
                let itemDict = item as! [String:String]
                
                guard let sku = itemDict["sku"], !sku.isEmpty,
                    let currency = itemDict["currency"], !currency.isEmpty,
                    let amount = itemDict["amount"], !amount.isEmpty else{
                        break
                }
                
                if transactionsDictionary[sku] != nil
                {
                    var skuTransactions = transactionsDictionary[sku]
                    if skuTransactions?[currency] == nil {
                        skuTransactions?[currency] = [Double(amount) ?? 0.0]
                    }
                    else{
                        skuTransactions?[currency]?.append(Double(amount) ?? 0.0)
                    }

                    transactionsDictionary[sku] = skuTransactions
                }
                else{
                    transactionsDictionary[sku] = [currency:[Double(amount) ?? 0.0]]
                }
            }
            print("After Reading transactions: \(transactionsDictionary)")
        }
        catch {
            print(error)
        }
    }
    
    public func getDataGroupedByTransactionsNumber() -> [[String:Int]]{
        var resultArray = [[String:Int]]()
        let skuArray = transactionsDictionary.keys
        for sku in skuArray{
            //sku is dictionary with currency key and array of all amounts values
            var sum = 0
            for currency in (transactionsDictionary[sku]?.keys)!{
                sum = sum + (transactionsDictionary[sku]?[currency]?.count ?? 0)
            }
            let newItem = [sku: sum]
            resultArray.append(newItem)
        }
        return resultArray
    }
    
    public func getDataGroupedByCurrency(sku:String) -> [String:[Double]]{
        return transactionsDictionary[sku] ?? [String:[Double]]()
    }
}
