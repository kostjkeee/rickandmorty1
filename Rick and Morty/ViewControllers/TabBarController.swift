//
//  TabBarController.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    
    
    
    
    
    private func setupTabBar() {
        let episodesVC = EpisodesViewController()
        let favouritesVC = FavouritesViewController()
        
        let episodesNavVC = UINavigationController(rootViewController: episodesVC)
        let favouritesNavVC = UINavigationController(rootViewController: favouritesVC)
        
        episodesNavVC.tabBarItem.image = UIImage(systemName: "house")
        favouritesNavVC.tabBarItem.image = UIImage(systemName: "heart")
        
        self.setViewControllers([episodesNavVC, favouritesNavVC], animated: true)
    }
    
}
