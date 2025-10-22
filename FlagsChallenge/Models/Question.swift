//
//  Question.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import Foundation

struct QuestionResult: Codable {
    let questions: [Question]
}

struct Question: Codable {
    let answerId: Int
    let countries: [Country]
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case countries
        case countryCode = "country_code"
    }
}


struct Country: Codable {
    let id: Int
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
    }
}
