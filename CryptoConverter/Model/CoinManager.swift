//
//  CoinManager.swift
//  CryptoConverter
//
//  Created by besim on 11.5.22.
//

import Foundation

let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
let apiKey = "4B6577EC-4E03-40C9-A825-605D5ADB2421"


struct CoinManager {
    
    var currency = ""
    
    
//    let URL = "\(baseURL)/\(currency)?apikey=\(apiKey)
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
     func getCoinPrice(for currency: String){
         print(currency)
        let URL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(url: URL)
    }
    
    func performRequest(url: String){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error:Error?){
        if error != nil{
            print(error!)
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: String.Encoding.utf8)
            parseJSON(coinData: safeData)
        }
    }
    
    func parseJSON(coinData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let price = decodedData.rate
            print(price)
            
        }catch{
            print(error)
        }
        
    }
    
    
}
