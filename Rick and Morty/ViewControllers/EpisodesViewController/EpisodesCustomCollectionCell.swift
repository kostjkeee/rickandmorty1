//
//  customCollectionCell.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


class EpisodesCustomCollectionCell: UICollectionViewCell {
    
    static let identifier1 = "EpisodeCustomCollectionCell1"
    static let identifier2 = "EpisodeCustomCollectionCell2"
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var link = EpisodesViewController()
    var link2 = FavouritesViewController()
    
    var favourite = [Favourite]()
    
    var isLikeTapped: Bool = false
    
    override func prepareForReuse() {
        self.characterImageView.image = nil
        self.episodeTextLabel.text = nil
        self.characterNameTextLabel.text = nil
        self.characterRaceTextLabel.text = nil
    }
    
    
    let characterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    let characterNameTextLabel = {
        let textLabel = UILabel()
        textLabel.text = "Rick Sanchez"
        textLabel.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    let characterRaceTextLabel = {
        let textLabel = UILabel()
        textLabel.text = "Human"
        textLabel.textColor = .darkGray
        textLabel.font = .systemFont(ofSize: 12)
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    let episodeUIView = {
        let episodeView = UIView()
        episodeView.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 0.1)
        episodeView.layer.cornerRadius = 10
        return episodeView
    }()
    
    let episodeImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "play.display")
        imageView.tintColor = UIColor.darkGray
        return imageView
    }()
    
    let episodeTextLabel = {
        let textLabel = UILabel()
        textLabel.text = "Pilot | S01E01"
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    let likeButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.contentVerticalAlignment = .fill
        likeButton.contentHorizontalAlignment = .fill
        likeButton.tintColor = UIColor(red: 1/255, green: 171/255, blue: 196/255, alpha: 1.0)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLikeButton() {
        UIView.animate(withDuration: 0.2) {
            self.likeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { finished in
            if finished {
                UIView.animate(withDuration: 0.2) {
                    self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }

    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        isLikeTapped = !isLikeTapped
        if isLikeTapped {
            animateLikeButton()
            print("Like Button Pressed")
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = UIColor.red
            
            
            link.addedToFavourites(cell: self)

            
            
        } else {
            animateLikeButton()
            print("Like Button Unpressed")
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = UIColor(red: 1/255, green: 171/255, blue: 196/255, alpha: 1.0)

            link.removedFromFavourites1(cell: self)
            
            
        }
        
        
    }
    
    
    func configure(character: Character, episodeText: (String, String), isFavorite: Bool) {
        
        self.characterImageView.image = nil
        addSpinner()
        
        DispatchQueue.main.async {
            self.episodeTextLabel.text = "\(episodeText.0) | \(episodeText.1)"
            self.characterNameTextLabel.text = character.name
            self.characterRaceTextLabel.text = character.species
            
            if let imageFromCache = imageCache.object(forKey: URL(string: character.image)!.absoluteString as AnyObject) as? UIImage {
                self.characterImageView.image = imageFromCache
                self.removeSpinner()
                return
            }
        }
        
        self.loadImage(url: character.image)
        
    }

    

    private func loadImage(url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageUrl = URL(string: url),
                  let data = try? Data(contentsOf: imageUrl),
                  let imageToLoad = UIImage(data: data) else { return }
            imageCache.setObject(imageToLoad, forKey: imageUrl.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.characterImageView.image = imageToLoad
                self.removeSpinner()
            }
        }
    }

    
    func addSpinner() {
        self.characterImageView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.characterImageView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.characterImageView.centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
    
    
    private func setupUI() {
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 0.7).cgColor
        self.contentView.layer.cornerRadius = 7
        
        self.contentView.layer.shadowOpacity = 0.5
//        self.contentView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.contentView.layer.shadowRadius = 1
       
        
        self.contentView.addSubview(characterImageView)
        self.contentView.addSubview(characterNameTextLabel)
        self.contentView.addSubview(characterRaceTextLabel)
        self.contentView.addSubview(episodeUIView)
        self.episodeUIView.addSubview(episodeImageView)
        self.episodeUIView.addSubview(episodeTextLabel)
        self.episodeUIView.addSubview(likeButton)
        

        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        characterRaceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeUIView.translatesAutoresizingMaskIntoConstraints = false
        episodeImageView.translatesAutoresizingMaskIntoConstraints = false
        episodeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 230),
            
            
            characterNameTextLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor,constant: 5),
            characterNameTextLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,constant: 12),
            characterNameTextLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            
            
            characterRaceTextLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 5),
            characterRaceTextLabel.topAnchor.constraint(equalTo: characterNameTextLabel.bottomAnchor,constant: 5),
            characterRaceTextLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            
            
            episodeUIView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            episodeUIView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            episodeUIView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            episodeUIView.heightAnchor.constraint(equalToConstant: 60),
            
            
            episodeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            episodeImageView.centerYAnchor.constraint(equalTo: self.episodeUIView.centerYAnchor),
            episodeImageView.widthAnchor.constraint(equalToConstant: 30),
            episodeImageView.heightAnchor.constraint(equalToConstant: 25),
            
            episodeTextLabel.leadingAnchor.constraint(equalTo: self.episodeImageView.trailingAnchor, constant: 10),
            episodeTextLabel.trailingAnchor.constraint(equalTo: self.likeButton.leadingAnchor,constant: 10),
            episodeTextLabel.centerYAnchor.constraint(equalTo: self.episodeUIView.centerYAnchor),
            episodeTextLabel.widthAnchor.constraint(equalToConstant:  60),
            
            likeButton.centerYAnchor.constraint(equalTo: self.episodeUIView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
          
        ])
    }
}
