//
//  ListSearchController.swift
//  pointercrate
//
//  Created by samara on 3/23/24.
//

import Foundation
import UIKit

extension ListViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
	
	func setupSearchController() {
		self.searchController.searchResultsUpdater = self
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.searchController.hidesNavigationBarDuringPresentation = true
		self.searchController.searchBar.placeholder = "Search Demons"
		
		self.navigationItem.searchController = searchController
		self.definesPresentationContext = false
		self.navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
			filteredDemons = demons.filter { $0.name.lowercased().contains(searchText) }
		} else {
			filteredDemons = demons
		}
		self.collectionView.reloadData()
	}
	
	public func inSearchMode(_ searchController: UISearchController) -> Bool {
		let isActive = searchController.isActive
		let searchText = searchController.searchBar.text ?? ""
		
		return isActive && !searchText.isEmpty
	}
	
}
