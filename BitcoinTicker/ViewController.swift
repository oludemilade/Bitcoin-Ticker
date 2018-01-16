//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NGN", "NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    //Determine how many columns we want
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // How many rows this picker should be using the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // Use the string from currency array as title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var currencySymbol : String = ""
        if currencyArray[row] == "AUD" || currencyArray[row] == "CAD" || currencyArray[row] == "HKD" || currencyArray[row] == "NZD" || currencyArray[row] == "SGD" || currencyArray[row] == "USD" || currencyArray[row] == "MXN" {
            currencySymbol.append("$")
        } else if currencyArray[row] == "BRL" {
            currencySymbol.append("R$")
        } else if currencyArray[row] == "CNY" {
            currencySymbol.append("¥")
        } else if currencyArray[row] == "GBP" {
            currencySymbol.append("£")
        } else if currencyArray[row] == "EUR" {
            currencySymbol.append("€")
        } else if currencyArray[row] == "IDR" {
            currencySymbol.append("Rp")
        } else if currencyArray[row] == "ILS" {
            currencySymbol.append("₪")
        } else if currencyArray[row] == "INR" {
            currencySymbol.append("₹")
        } else if currencyArray[row] == "JPY" {
            currencySymbol.append("¥")
        } else if currencyArray[row] == "NGN" {
            currencySymbol.append("₦")
        } else if currencyArray[row] == "NOK" || currencyArray[row] == "SEK" {
            currencySymbol.append("kr")
        } else if currencyArray[row] == "PLN" {
            currencySymbol.append("zł")
        } else if currencyArray[row] == "RON" {
            currencySymbol.append("lei")
        } else if currencyArray[row] == "RUB" {
            currencySymbol.append("₽")
        } else if currencyArray[row] == "ZAR" {
            currencySymbol.append("R")
        }
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitcoinData(url: finalURL, currencySymbol: currencySymbol)
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String, currencySymbol : String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let BitcoinJSON : JSON = JSON(response.result.value!)
                    print(BitcoinJSON)
                    self.updateBitcoinData(json: BitcoinJSON, currencySymbol : currencySymbol)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

//
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinData(json : JSON, currencySymbol : String) {
        if let tempResult = json["ask"].double {
            bitcoinPriceLabel.text = currencySymbol + " " + String(tempResult)
        } else {
           bitcoinPriceLabel.text = "Bitcoin Data Unavailable"
        }
        
    }

}

