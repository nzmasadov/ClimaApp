//
//  WeatherData.swift
//  ClimaApp
//
//  Created by Nazim Asadov on 14.02.22.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Detailed]
}

struct Main: Codable {
    let temp: Double
}

struct Detailed: Codable {
    let description: String
    let id: Int
}
