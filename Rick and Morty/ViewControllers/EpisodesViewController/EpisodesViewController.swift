//
//  EpisodesViewController.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    var isSearching = false
    
    static var indexesUsed = [Int]()
    static var isDeleted = false
    static var index: Int?
    
    var isByEpisodeName: Bool = false
    var isByEpisodeNumber: Bool = true
    var isByCharacterName: Bool = false

    var episodeItem = [Favourite]()
    var filteredEpisoedItem = [Favourite]()
    var episodes = [Results]()
    

    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Name or episode (ex.S01E01)"
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setTitle("ADVANCED FILTERS", for: .normal)
        filterButton.setTitleColor(UIColor(red: 47/255, green: 156/255, blue: 243/255, alpha: 1.0), for: .normal)
        filterButton.backgroundColor = UIColor(red: 227/255, green: 242/255, blue: 253/255, alpha: 1.0)
        filterButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -180, bottom: 0, right: 0)
        filterButton.layer.borderColor = UIColor.gray.cgColor
        filterButton.layer.borderWidth = 0.5
        filterButton.layer.cornerRadius = 6
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        return filterButton
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EpisodesCustomCollectionCell.self, forCellWithReuseIdentifier: EpisodesCustomCollectionCell.identifier1)
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        fetchData()
        setupUI()
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.episodeItem = self.episodeItem.sorted {$0.episodeNumber < $1.episodeNumber}
            self.collectionView.reloadData()
        }
    }
    
    
    private func fetchData() {
        let urlString = "https://rickandmortyapi.com/api/episode"
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            let jsonEpisodes = try decoder.decode(Episodes.self, from: safeData)
                            self.episodes = jsonEpisodes.results
                            for episode in self.episodes {
                                self.fetchCharacter(episode: episode) { character in
                                    self.episodeItem.append(Favourite(episodeName: episode.name, episodeNumber: episode.episode, character: character!, isFavourite: false))
                                }
                            }
                            
                        } catch {
                            print("Error parsing json from your Episodes Model: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    
    func fetchCharacter(episode: Results, completionHandler: @escaping (Character?) -> Void) {
        
        let characterArrayMaxAmount = episode.characters.count
        let urlToRandomCharacter = episode.characters[Int.random(in: 0..<characterArrayMaxAmount)]

        
        DispatchQueue.global(qos: .userInitiated).async {

        if let url = URL(string: urlToRandomCharacter) {
            
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            let jsonCharacter = try decoder.decode(Character.self, from: safeData)
                            DispatchQueue.main.async {
                                completionHandler(jsonCharacter)
                            }
                        } catch {
                            print("Error parsing json from your Characters Model: \(error)")
                        }
                    }
                    
                }
                task.resume()
            }
        }
        
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Search...", message: nil, preferredStyle: .actionSheet)
        let firstButton = (UIAlertAction(title: "By episode number", style: .default, handler: { action in
            self.isByEpisodeNumber = true
            self.isByCharacterName = false
            self.isByEpisodeName = false
        }))
        
        firstButton.setValue(isByEpisodeNumber, forKey: "checked")
        
        let secondButton = (UIAlertAction(title: "By episode name", style: .default, handler: { action in
            self.isByEpisodeNumber = false
            self.isByCharacterName = false
            self.isByEpisodeName = true
        }))
        
        secondButton.setValue(isByEpisodeName, forKey: "checked")

        
        let thirdButton = (UIAlertAction(title: "By character name", style: .default, handler: { action in
            self.isByEpisodeNumber = false
            self.isByCharacterName = true
            self.isByEpisodeName = false
        }))
        
        thirdButton.setValue(isByCharacterName, forKey: "checked")

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(firstButton)
        ac.addAction(secondButton)
        ac.addAction(thirdButton)
        present(ac,animated: true)
    }

    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.titleView = logoImageView
        
        self.view.addSubview(collectionView)
        self.view.addSubview(logoImageView)
        self.view.addSubview(searchBar)
        self.view.addSubview(filterButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchBar.leadingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.trailingAnchor),

            
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 10),
            filterButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            filterButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21),
            filterButton.widthAnchor.constraint(equalToConstant: 312),
            filterButton.heightAnchor.constraint(equalToConstant: 56),
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
        ])
    }
    
    //MARK: - Methods for adding and deleting from favourites
    
    func addedToFavourites(cell: EpisodesCustomCollectionCell) {
        EpisodesViewController.isDeleted = false

        var episodeName:String!
        var episodeNumber:String!
        var character: Character!
        
        let indexPathTapped = collectionView.indexPath(for: cell)
        
        if isSearching {
            
            episodeName = filteredEpisoedItem[indexPathTapped!.item].episodeName
            episodeNumber = filteredEpisoedItem[indexPathTapped!.item].episodeNumber
            character = filteredEpisoedItem[indexPathTapped!.item].character
            
        } else {
            
            episodeName = episodeItem[indexPathTapped!.item].episodeName
            episodeNumber = episodeItem[indexPathTapped!.item].episodeNumber
            character = episodeItem[indexPathTapped!.item].character
            
        }
        
        if !EpisodesViewController.indexesUsed.contains(indexPathTapped!.item) {
            print(indexPathTapped!.item)
            FavouritesViewController.favouriteEpisodes.append(Favourite(episodeName: episodeName, episodeNumber: episodeNumber, character: character, isFavourite: true))
            EpisodesViewController.indexesUsed.append(indexPathTapped!.item)
            
            FavouritesViewController.save()
        }

    }
    
    func removedFromFavourites1(cell: UICollectionViewCell) {
        if EpisodesViewController.isDeleted == false {
            let indexPathTapped = collectionView.indexPath(for: cell)
            
            //ne znayu kak realizovat' bez oshibki index out of range
//            FavouritesViewController.favouriteEpisodes.remove(at: indexPathTapped!.item)
            
//            EpisodesViewController.isDeleted = true
//            if !EpisodesViewController.indexesUsed.isEmpty {
//                EpisodesViewController.indexesUsed.remove(at: indexPathTapped!.item)
//            }
        }
    }
    
    
}

//MARK: -  CollectionView Delegate, Data Source

extension EpisodesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching {
                return filteredEpisoedItem.count
        }
        
        return episodeItem.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCustomCollectionCell.identifier1, for: indexPath) as? EpisodesCustomCollectionCell else { fatalError("Couldn't find any CollectionViewCell with this identifier") }
        
        cell.link = self
        
        var item: Favourite!
        
        if !episodeItem.isEmpty {
            item = episodeItem[indexPath.item]
            
            if isSearching {
                item = filteredEpisoedItem[indexPath.item]
                
                cell.configure(character: item.character, episodeText: (item.episodeName, item.episodeNumber), isFavorite: false)
            } else {
                cell.configure(character: item.character, episodeText: (item.episodeName, item.episodeNumber), isFavorite: false)
            }
            
                
            
            if EpisodesViewController.isDeleted == true && EpisodesViewController.index == indexPath.item {
                cell.isLikeTapped = false
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = UIColor(red: 1/255, green: 171/255, blue: 196/255, alpha: 1.0)
                print("cell was refreshed in episodes vc")
            }
            
        }
        return cell
    }
       
        
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        if isSearching {
            vc.detailCharacter = filteredEpisoedItem[indexPath.item].character
        } else {
            vc.detailCharacter = episodeItem[indexPath.item].character
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: - CollectionView Flow Layout Delegate

extension EpisodesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 357)
    }
    
    
    //vertial spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    
    
}



//MARK: - Search Bar Delegate
extension EpisodesViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false

        if searchBar.text != "" {
            isSearching = true
            collectionView.reloadData()
        }
        self.searchBar.resignFirstResponder()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredEpisoedItem.removeAll()
        let text = searchText

        if isByEpisodeNumber {
            if text == "" {
                isSearching = false
                collectionView.reloadData()
            } else {
                isSearching = true
            
                filteredEpisoedItem = episodeItem.filter({ $0.episodeNumber.replacingOccurrences(of: "S01", with: "").lowercased().contains(text.lowercased()) && $0.episodeNumber.replacingOccurrences(of: "S02", with: "").lowercased().contains(text.lowercased())
                })
                collectionView.reloadData()
            }
        } else if isByEpisodeName {
            if text == "" {
                isSearching = false
                collectionView.reloadData()
            } else {
                isSearching = true
                filteredEpisoedItem = episodeItem.filter({ $0.episodeName.lowercased().contains(text.lowercased())})
                collectionView.reloadData()
            }
        } else if isByCharacterName {
            if text == "" {
                isSearching = false
                collectionView.reloadData()
            } else {
                isSearching = true
                filteredEpisoedItem = episodeItem.filter({ $0.character.name.lowercased().contains(text.lowercased())})
                collectionView.reloadData()
            }
        }
        
    }
}
