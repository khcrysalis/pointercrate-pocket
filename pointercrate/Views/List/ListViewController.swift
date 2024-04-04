//
//  ListViewController.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import UIKit
import SwiftUI

class ListViewController: UIViewController {
    
    public var collectionView: UICollectionView!
	private lazy var emptyStackView = EmptyPageStackView()
	public var searchController = UISearchController(searchResultsController: nil)

    private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
    
	public var demons: [Demons] = []
    public var filteredDemons: [Demons] = []
	private var isLoadingMoreDemons = false
    
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
		self.view.backgroundColor = UIColor(named: "Background")
		self.collectionView.backgroundColor = UIColor(named: "Background")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ListDemonCell.self, forCellWithReuseIdentifier: "DemonCell")
        self.collectionView.register(ListHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListHeaderCollectionReusableView.identifier)
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // empty text view
        emptyStackView.isHidden = true
        emptyStackView.title = "No Entries"
        emptyStackView.text = "Check your internet connection and try again"
        emptyStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStackView)

        NSLayoutConstraint.activate([
            emptyStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
		self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.center = view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(refreshDemons(_:)), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDemons(_:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    fileprivate func setupNavigation() {
        let customView = UIView()
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
        
        let n = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(apiAboutButtonTapped))
        self.navigationItem.rightBarButtonItem = n
    }
    
    @objc func apiAboutButtonTapped() {
        let viewController = APIAboutViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if let presentationController = navigationController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(navigationController, animated: true)
    }

}


extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if inSearchMode(searchController) {
			return filteredDemons.count
		} else {
			return demons.count
		}
	}
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ListHeaderCollectionReusableView.identifier,
                for: indexPath
            ) as! ListHeaderCollectionReusableView
            headerView.filterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            headerView.title = ListOption(rawValue: Filter.selectedList)?.title
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        let filterView = UIHostingController(rootView: ListFilterView())
        filterView.modalPresentationStyle = .pageSheet
        filterView.sheetPresentationController?.detents = [.medium(), .large()]
        self.present(filterView, animated: true, completion: nil)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(
            width: view.frame.size.width,
            height: 50
        )
    }
    
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemonCell", for: indexPath) as! ListDemonCell
		let demon: Demons
		
		if inSearchMode(searchController) {
			demon = filteredDemons[indexPath.item]
		} else {
			demon = demons[indexPath.item]
		}
		
		cell.configure(with: demon)
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        
        let screenWidth = collectionView.bounds.width
        var contentWidth: CGFloat = 0
        
        contentWidth = screenWidth - sectionInset.left - sectionInset.right
        
        return CGSize(width: contentWidth, height: 150)
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let demon: Demons
		
		if inSearchMode(searchController) {
			demon = filteredDemons[indexPath.item]
		} else {
			demon = demons[indexPath.item]
		}
		
		let demonVC = DemonViewController()
		demonVC.demonID = demon.id
		navigationController?.pushViewController(demonVC, animated: true)
	}
}

extension ListViewController: UICollectionViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height {
			if Filter.selectedList == 2 && !isLoadingMoreDemons {
				loadMoreDemons()
			}
		}
	}
}

extension ListViewController {
    @objc private func refreshDemons(_ sender: Any) { loadDemons() }
    func loadDemons() {
		ListOption(rawValue: Filter.selectedList)?.updateFilter()
        Task {
            do {
                self.demons = try await PointercrateAPI.shared.getRankedDemons(name: Filter.name,
                                                                               nameContains: Filter.nameContains,
                                                                               requirement: Filter.requirement,
                                                                               verifierID: Filter.verifierID,
                                                                               publisherID: Filter.publisherID,
                                                                               verifierName: Filter.verifierName,
                                                                               publisherName: Filter.publisherName,
                                                                               limit: Filter.limit,
                                                                               after: Filter.after,
                                                                               before: Filter.before)
            
				DispatchQueue.main.async {
					UIView.animate(withDuration: 0.2, animations: {
						self.collectionView.alpha = 0
						self.activityIndicator.alpha = 0
					}, completion: { _ in
						self.collectionView.reloadData()
						self.collectionView.refreshControl?.endRefreshing()
						self.activityIndicator.stopAnimating()
						
						UIView.animate(withDuration: 0.2, animations: {
							self.collectionView.alpha = 1
						})
					})
				}
                
            } catch {
				print("Error fetching demons: \(error)")
				DispatchQueue.main.async {
					
					UIView.animate(withDuration: 0.2, animations: {
						self.emptyStackView.alpha = 0
					}, completion: { _ in
						self.collectionView.refreshControl?.endRefreshing()
						self.activityIndicator.stopAnimating()
						self.emptyStackView.isHidden = false
						
						UIView.animate(withDuration: 0.2, animations: {
							self.emptyStackView.alpha = 1
						})
						
					})
				}
			}
        }
    }
	
	func loadMoreDemons() {
		isLoadingMoreDemons = true
		Filter.after! += Filter.limit
		Task {
			do {
				let moreDemons = try await PointercrateAPI.shared.getRankedDemons(name: Filter.name,
																				   nameContains: Filter.nameContains,
																				   requirement: Filter.requirement,
																				   verifierID: Filter.verifierID,
																				   publisherID: Filter.publisherID,
																				   verifierName: Filter.verifierName,
																				   publisherName: Filter.publisherName,
																				   limit: Filter.limit,
																				   after: Filter.after,
																				   before: Filter.before)
				self.demons.append(contentsOf: moreDemons)
				DispatchQueue.main.async {
					let startIndex = self.demons.count - moreDemons.count
					let endIndex = self.demons.count
					let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
					self.collectionView.performBatchUpdates({
						self.collectionView.insertItems(at: indexPaths)
					}, completion: { _ in
						self.isLoadingMoreDemons = false
					})
				}
			} catch {
				print("Error fetching more demons: \(error)")
				self.isLoadingMoreDemons = false
			}
		}
	}
}
