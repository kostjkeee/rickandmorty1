//
//  LocationTableCell.swift
//  Rick and Morty
//
//  Created by Kostya Khvan on 10.12.2023.
//

import UIKit

class LocationTableCell: UITableViewCell {

    static let identifier = "LocationTableCell"

    let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Location"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    let detailLabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .lightGray
        titleLabel.text = "Detail"
        return titleLabel
    }()
    
    
    func configure(text: String) {
        DispatchQueue.main.async {
            self.detailLabel.text = text
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor,constant: 08),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor,constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 2),
            detailLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            detailLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant:  -18)

        ])
    }

}
