//
//  ViewController.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 06.12.2023.
//

import UIKit

class LaunchViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    private let loadingImageView: UIImageView = {
        let loadingImageView = UIImageView(image: UIImage(named: "loading"))
        return loadingImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
        animateLoadingImage()
        navigationController?.isNavigationBarHidden = true
    }

    private func animateLoadingImage() {
        UIView.animate(withDuration: 3, delay: 0.0, options: [.curveLinear]) {
            self.loadingImageView.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { finished in
            if finished {
                let vc = TabBarController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }

    }
    
    
    
    

    private func setupUI() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(loadingImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 280),
            loadingImageView.heightAnchor.constraint(equalToConstant: 240),
            
            
            logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 312),
            logoImageView.heightAnchor.constraint(equalToConstant: 104)
            
            
        ])
    }
}

