//
//  ListCollectionReusableView.swift
//  pointercrate
//
//  Created by samara on 3/24/24.
//

import Foundation
import UIKit

protocol ListHeaderCollectionReusableViewDelegate: AnyObject {
    
}
class ListHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ListHeaderCollectionReusableView"
    
    var titleLabel = UILabel()
    let filterButton = UIButton(type: .roundedRect)
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        
        titleLabel.text = "Main"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)

        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(filterButton)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

