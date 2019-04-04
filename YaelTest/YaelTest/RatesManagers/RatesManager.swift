//
//  RatesManager.swift
//  YaelTest
//
//  Created by  Mac on 03/04/2019.
//  Copyright © 2019 YaelB. All rights reserved.
//

import Foundation
class RatesManager{
    // MARK: - Properties
    
    //singletone
    static let shared = RatesManager()
    /*
     ratesDictionary should set with:
     key = "to" value
     value = subDictionary
     
     subDictionary should set with:
     key = "from" value
     value = "rate" value
     */
    var ratesDictionary:[String: [String: String]]
    
    //MARK: - Private Functions
    
    private init(){
        //read rates from file
        ratesDictionary = [String: [String: String]]()
        if updateRatesFromFile(){
            updateAllMissingData()
        }
    }
    
    private func updateRatesFromFile() -> Bool{
        let url = Bundle.main.url(forResource: ratesFile, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            
            //parser it to ratesDictionary
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            for item in json{
                let itemDict = item as! [String:String]
                guard let toCurrency = itemDict["to"],
                let fromCurrency = itemDict["from"],
                let rate = itemDict["rate"] else{
                    continue
                }
                
                if ratesDictionary[toCurrency] != nil
                {
                    ratesDictionary[toCurrency]![fromCurrency] = rate
                }
                else{
                    let newDictionaryItem = [fromCurrency : rate]
                    ratesDictionary[toCurrency] = newDictionaryItem
                }
            }
            print("After Reading Rates: \(ratesDictionary)")
            return true
        }
        catch {
            print(error)
        }
        return false
    }
    
    /*
     learn the missing rates by existing rates
     */
    private func updateAllMissingData(){
        //move all over the coins and update missing data for every key
        
        for coinKey in ratesDictionary.keys{
            let coinDictionary = ratesDictionary[coinKey]
            
            //if coin has any updated rates
            if coinDictionary != nil{
                for key in coinDictionary!.keys{
                    if key != coinKey{
                        //update missing data by every known rate
                        updateMissingData(from: key, to: coinKey, rate: (coinDictionary?[key])!)
                    }
                }
            }
        }
        print("After Adding Missing Rates: \(ratesDictionary)")
    }
    
    /*
     by getting specific from to and rate, update all missing data that you can by these properties
     */
    private func updateMissingData(from:String, to:String, rate:String){
        //get all known rates from "from" coin
        let ratesByCoin = ratesDictionary[from]
        if ratesByCoin != nil{
            //moving on his keys
            for key in ratesByCoin!.keys{
                if key != to{
                    //update missing rates by multiple rate with the known rate
                    if !((ratesDictionary[to]?[key]) != nil){
                        let newRate = Double(rate)!*Double(ratesByCoin![key]!)!
                        ratesDictionary[to]?[key] = String(newRate)
                        updateMissingData(from: key, to: to, rate: String(newRate))
                    }
                }
            }
        }
    }
    
    //MARK: - Public Functions
    
    /*
     convert amount from coin to coin
     return value is String because I saw you dealed only with string so I continue with that
     */
    public func convert(amount:Double, fromCoins:String, toCoin:String) -> Double{
        let rates = ratesDictionary[toCoin]
        let rate = rates?[fromCoins]
        if rate != nil {
            let doubleRate = Double(rate!)
            if doubleRate != nil && amount > 0 {
                return amount*doubleRate!
            }
        }
        return 0.0
    }
}
