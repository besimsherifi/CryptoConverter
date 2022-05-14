//
//  CoinManager.swift
//  CryptoConverter
//
//  Created by besim on 11.5.22.
//

import Foundation

let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
let apiKey = "4B6577EC-4E03-40C9-A825-605D5ADB2421"

protocol CoinManagerDelegate {
    func didUpdatePrice(currency: String, price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    
    var delegate: CoinManagerDelegate?
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
     func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
         if let url = URL(string: urlString){
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
             task.resume()
         }
         func handle(data: Data?, response: URLResponse?, error:Error?){
             if error != nil{
                 self.delegate?.didFailWithError(error: error!)
                 return
             }
             if let safeData = data {
                 if let bitcoinPrice = self.parseJSON(coinData: safeData){
                 let price = String(format: "%.2f", bitcoinPrice)
                 self.delegate?.didUpdatePrice(currency: currency, price: price)
                 }
             }
         }
    }
    
    
       
    
    
  
    
    func parseJSON(coinData: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let price = decodedData.rate
            return price
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}
