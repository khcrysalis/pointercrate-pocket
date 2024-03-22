//
//  DemonCell.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

class DemonCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let creatorLabel = UILabel()
    private let positionLabel = UILabel()
    
    private let thumbnailImageView = UIImageView()
    private var gradientApplied = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.tertiarySystemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
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
    
    func configure(with demon: RankedDemons) {
        nameLabel.text = demon.name.description
        creatorLabel.text = demon.publisher.name + " | " + "ID: " + String(demon.id)
        positionLabel.text = "#" + demon.position.description
        
        if let videoURL = URL(string: demon.video), let videoID = videoURL.queryParameters?["v"] {
            let thumbnailURLString = "https://i.ytimg.com/vi/\(videoID)/mqdefault.jpg"
            
            if let thumbnailURL = URL(string: thumbnailURLString) {
                DispatchQueue.global().async {
                    if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: thumbnailURL)),
                       let image = UIImage(data: cachedResponse.data) {
                        DispatchQueue.main.async {
                            self.thumbnailImageView.image = image
                            if !self.gradientApplied {
                                self.thumbnailImageView.createGradientBlur()
                                self.gradientApplied = true
                            }
                        }
                    } else {
                        URLSession.shared.dataTask(with: thumbnailURL) { (data, response, error) in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.thumbnailImageView.image = image
                                    if !self.gradientApplied {
                                        self.thumbnailImageView.createGradientBlur()
                                        self.gradientApplied = true
                                    }
                                }
                                let cachedResponse = CachedURLResponse(response: response!, data: data)
                            
                                URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: thumbnailURL))
                            }
                        }
                        .resume()
                    }
                }
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
