//
//  DemonCell.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit
import Nuke
import NukeExtensions

class DemonCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let creatorLabel = UILabel()
    private let positionLabel = UILabel()
    
    private let thumbnailImageView = GradientBlurImageView()
    private var gradientApplied = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.cornerRadius = 16
        layer.borderWidth = 1.5
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        if isDarkMode {
            layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        } else {
            layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        }
        
        layer.masksToBounds = true
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.contentMode = .scaleAspectFill
        contentView.addSubview(thumbnailImageView)

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize + 3.0)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorLabel.textColor = .lightText
        creatorLabel.textAlignment = .left
        creatorLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(creatorLabel)
        
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.textColor = .lightText
        positionLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(positionLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            creatorLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
            
            positionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            positionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        if isDarkMode {
            layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        } else {
            layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        }
    }

    
    func configure(with demon: Demons) {
        nameLabel.text = demon.name.description
        creatorLabel.text = demon.publisher.name + " | " + "ID: " + String(demon.id)
        positionLabel.text = "#" + demon.position.description
        
        thumbnailImageView.image = nil
        
        if let thumbnailURL = URL(string: demon.thumbnail!) {
            let request = ImageRequest(url: thumbnailURL)
            
            if let image = ImagePipeline.shared.cache.cachedImage(for: request) {
                thumbnailImageView.image = image.image
            } else {
                ImagePipeline.shared.loadImage(
                    with: request,
                    progress: nil,
                    completion: { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let imageResponse):
                            DispatchQueue.main.async {
                                if self.nameLabel.text == demon.name.description {
                                    self.thumbnailImageView.image = imageResponse.image
                                }
                            }
                        case .failure(let error):
                            print("Image loading failed with error: \(error)")
                        }
                    }
                )
            }
        }
    }
    
    
    
    
    
    // https://stackoverflow.com/a/54395216
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}
