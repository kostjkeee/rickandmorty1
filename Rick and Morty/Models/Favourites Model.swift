//
//  Favourites Model.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 11.12.2023.
//

import Foundation


struct Favourite: Codable {
    let episodeName: String
    let episodeNumber: String
    let character: Character
    let isFavourite: Bool
}
