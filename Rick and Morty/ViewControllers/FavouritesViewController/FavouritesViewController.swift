//
//  Favourites.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import UIKit


class FavouritesViewController: UIViewController {
    
    static var favouriteEpisodes = [Favourite]()
    static var isDeleted = false
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavouriteCustomCollectionCell.self, forCellWithReuseIdentifier: FavouriteCustomCollectionCell.identifier)
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = .systemBackground
        navigationItem.title = "Favourites"
        setupFavouritesUI()
        fetchDataFromDefaults()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func fetchDataFromDefaults() {
        let defaults = UserDefaults.standard
        if let savedFavourites = defaults.data(forKey: "favourites") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                FavouritesViewController.favouriteEpisodes = try jsonDecoder.decode([Favourite].self, from: savedFavourites)
            } catch {
                print("Failed to load favourites from UserDefaults")
            }
        }
    }
    
    static func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(FavouritesViewController.favouriteEpisodes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "favourites")
        } else {
            print("Failed to save favourites")
        }
    }
    
    
    func removedFromFavourites2(cell: FavouriteCustomCollectionCell) {
        
        let indexPathOfCell = collectionView.indexPath(for: cell)
                
        FavouritesViewController.favouriteEpisodes.remove(at: indexPathOfCell!.item)
        if !EpisodesViewController.indexesUsed.isEmpty {
            EpisodesViewController.indexesUsed.remove(at: indexPathOfCell!.item)
        }
        EpisodesViewController.isDeleted = true
        EpisodesViewController.index = indexPathOfCell!.item
        FavouritesViewController.save()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    
    private func setupFavouritesUI() {
        
        self.view.addSubview(collectionView)        
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
  
    
}



//MARK: - COllectionView Delegate, Data Source

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  FavouritesViewController.favouriteEpisodes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCustomCollectionCell.identifier, for: indexPath) as? FavouriteCustomCollectionCell else { fatalError("Couldn't find any CollectionViewCell with this identifier") }
        
        cell.link = self
        
        let favourite = FavouritesViewController.favouriteEpisodes[indexPath.item]
        
        
            cell.configure(character: favourite.character, episodeText: (favourite.episodeName, favourite.episodeNumber))
            cell.isLikeTapped = true
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = UIColor.red
            
            
        return cell
    }
    
    
                       
                       
                       
                       
}




//MARK: - CollectionView Flow Layout Delegate

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 357)
    }
    
    
    //vertial spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailCharacter = FavouritesViewController.favouriteEpisodes[indexPath.item].character
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
