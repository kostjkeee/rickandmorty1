//
//  DetailViewController.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 10.12.2023.
//
import Photos
import UIKit

class DetailViewController: UIViewController {
    
    let picker = UIImagePickerController()
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var detailCharacter: Character!
    let tableView = {
        let tableView = UITableView()
        tableView.register(GenderTableCell.self, forCellReuseIdentifier: GenderTableCell.identifier)
        tableView.register(StatusTableCell.self, forCellReuseIdentifier: StatusTableCell.identifier)
        tableView.register(SpeciesTableCell.self, forCellReuseIdentifier: SpeciesTableCell.identifier)
        tableView.register(OriginTableCell.self, forCellReuseIdentifier: OriginTableCell.identifier)
        tableView.register(TypeTableCell.self, forCellReuseIdentifier: TypeTableCell.identifier)
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.identifier)
        tableView.allowsSelection = false
        return tableView
    }()
    
    
    let userImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemBackground
        iv.layer.cornerRadius = 75
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let userNameLabel = {
        let textLabel = UILabel()
        textLabel.text = "Rick Sanchez"
        textLabel.textColor = .black
        textLabel.font = .systemFont(ofSize: 30)
        return textLabel
    }()
    
    let photoIconButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "detailicon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        setupDetailUI()

    }
    
    @objc func buttonTapped() {
        
        picker.delegate = self
        picker.allowsEditing = true
        
        let ac = UIAlertController(title: "Загрузите изображение", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            self?.picker.sourceType = .camera
            self?.present(self!.picker, animated: true)
        }
        
        let action2 = UIAlertAction(title: "Галерея", style: .default) { [weak self] _ in
            self?.checkGalleryPermission()
            self?.picker.sourceType = .photoLibrary
        }
        
        let action3 = UIAlertAction(title: "Отмена", style: .cancel)
        
        ac.addAction(action1)
        ac.addAction(action2)
        ac.addAction(action3)
        present(ac,animated: true)
    }
    
    
    
    func addSpinner() {
        self.userImageView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.userImageView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.userImageView.centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
    
    private func setupDetailUI() {
        self.view.addSubview(tableView)
        self.view.addSubview(userImageView)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(photoIconButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        photoIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 150),
            userImageView.heightAnchor.constraint(equalToConstant: 150),
            
            
            photoIconButton.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            photoIconButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            photoIconButton.widthAnchor.constraint(equalToConstant: 30),
            photoIconButton.heightAnchor.constraint(equalToConstant: 25),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    
    
    func checkGalleryPermission() {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authStatus {
            
        case .denied :
            print("denied status")
            let alert = UIAlertController(title: "Error", message: "Photo library status is denied", preferredStyle: .alert)
            let cancelaction = UIAlertAction(title: "Cancel", style: .default)
            let settingaction = UIAlertAction(title: "Setting", style: UIAlertAction.Style.default) { UIAlertAction in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                }
            }
            alert.addAction(cancelaction)
            alert.addAction(settingaction)
            self.present(alert,animated: true, completion: nil)
            
        case .authorized :
            print("success")
            DispatchQueue.main.async {
                self.present(self.picker, animated: true)
            }
            
        case .restricted :
            print("user dont allowed")
            
        case .notDetermined :
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    print("permission granted")
                    DispatchQueue.main.async {
                        self.present(self.picker, animated: true)
                    }
                }
                else {
                    print("permission not granted")
                }
            })
            
        case .limited:
            print("limited")
            
        @unknown default:
            break
        }
    }
}
    
    
    
    
    
    
    
    



//MARK: - TableView Data Source, Delegate 

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        self.userImageView.image = nil
        addSpinner()
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableCell.identifier, for: indexPath) as! GenderTableCell
            cell.configure(text: detailCharacter.gender)
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableCell.identifier, for: indexPath) as! StatusTableCell
            cell.configure(text: detailCharacter.status)
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeciesTableCell.identifier, for: indexPath) as! SpeciesTableCell
            cell.configure(text: detailCharacter.species)
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OriginTableCell.identifier, for: indexPath) as! OriginTableCell
            cell.configure(text: detailCharacter.origin.name)
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeTableCell.identifier, for: indexPath) as! TypeTableCell
            cell.configure(text: detailCharacter.type)
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableCell.identifier, for: indexPath) as! LocationTableCell
            cell.configure(text: detailCharacter.location.name)
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableCell.identifier)

        DispatchQueue.main.async {
            self.userNameLabel.text = self.detailCharacter.name
            self.removeSpinner()
        }
        
        if let imageFromCache = imageCache.object(forKey: URL(string: detailCharacter.image)!.absoluteString as AnyObject) as? UIImage {
            self.userImageView.image = imageFromCache
            self.removeSpinner()
        }
        
              
        return cell!
    }
    
   
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}






extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        userImageView.image = image
//        tableView.reloadData()
        dismiss(animated: true)
    }
}
