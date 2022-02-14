//
//  WeatherManager.swift
//  ClimaApp
//
//  Created by Nazim Asadov on 14.02.22.
//

import Foundation
import UIKit
import CoreLocation

protocol ModelManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
    }

struct WeatherManager {
    var weatherCity = "https://api.openweathermap.org/data/2.5/weather?appid=b298a0aa3263766c4c22767c980de88b&units=metric"
    
    var delegate: ModelManagerDelegate?
    
    func fetchWeather (cityname: String) {
        let urlString = "\(weatherCity)&q=\(cityname)"
        print(urlString)
        performRequest(with: urlString)
        
    }
    
    func fetchManager (latidute: CLLocationDegrees , longitude: CLLocationDegrees) {
            let urlString = "\(weatherCity)lat=\(latidute)&lon=\(longitude)"
            performRequest(with: urlString)
        print(urlString)
            
    }
    
    func performRequest (with urlString:String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                 
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decoderData.name
            let temp = decoderData.main.temp
            let id = decoderData.weather[0].id
            
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            
            return weather
            
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
}

