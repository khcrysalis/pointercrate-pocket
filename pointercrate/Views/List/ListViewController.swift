//
//  ListViewController.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import UIKit

class ListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
    public var searchController = UISearchController(searchResultsController: nil)

    private var demons: [Demons] = []
    private var filteredDemons: [Demons] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSearchController()
        setupViews()
        loadDemons()
    }
    
    fileprivate func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.secondarySystemBackground
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(DemonCell.self, forCellWithReuseIdentifier: "DemonCell")
        self.view.addSubview(collectionView)
        self.collectionView.constraintCompletely(to: view)
        
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.center = view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(refreshDemons(_:)), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    fileprivate func setupNavigation() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Demon List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        customView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
        ])
        self.navigationItem.title = nil
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: customView)]
        
        let n = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = n //uimenu to sort
    }
}


extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return demons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemonCell", for: indexPath) as! DemonCell
        let demon = demons[indexPath.item]
        cell.configure(with: demon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 33, height: 150)
    }
}

extension ListViewController {
    @objc private func refreshDemons(_ sender: Any) { loadDemons() }
    func loadDemons() {
        
        Task {
            do {
                self.demons = try await PointercrateAPI.shared.getRankedDemons(limit: 75)
            
                DispatchQueue.main.async {
                    UIView.transition(with: self.view, duration: 0.4, options: .transitionFlipFromTop, animations: {
                        self.collectionView.reloadData()
                        self.collectionView.refreshControl?.endRefreshing()
                        self.activityIndicator.stopAnimating()
                    }, completion: nil)
                }
                
            } catch {
                print("Error fetching demons: \(error)")
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}//backButtonDisplayMode = .minimal
