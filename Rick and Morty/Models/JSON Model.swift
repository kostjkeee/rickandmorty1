//
//  Episodes Model.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import Foundation


struct Episodes: Codable {

    let results: [Results]
}

struct Results: Codable {
    let name: String
    let episode: String
    let characters: [String]
}

struct Character: Codable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let type: String
    let origin: Origin
    let location: Location
    let image: String
    
    
    struct Origin: Codable {
        let name: String
    }

    struct Location: Codable {
        let name: String
    }
}


