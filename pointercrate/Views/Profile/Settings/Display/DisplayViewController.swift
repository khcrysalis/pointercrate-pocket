//
//  DisplayViewController.swift
//  nekofiles
//
//  Created by samara on 2/24/24.
//

import UIKit

class DisplayViewController: UIViewController {
	var tableView: UITableView!

	let tableData = [
		["Appearence"],
		["Collection View"]
	]
	
	var sectionTitles = [
		"",
		"Tint Color"
	]
	
	let collectionData = ["Default", "Berry", "Banana", "Sky", "Orange", "Peach", "Dragon", "Cactus", "Lime"]
	let collectionDataColors = ["ff7a83", "306598", "faef91", "6acef6", "ffbd7a", "ebcb8d", "eb8db4", "75d651", "79ed96"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Display"

		self.tableView = UITableView(frame: .zero, style: .insetGrouped)
		self.tableView.backgroundColor = UIColor(named: "Background")
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(tableView)
		self.tableView.constraintCompletely(to: view)
	}
	
	func updateAppearance(with style: UIUserInterfaceStyle) {
		view.window?.overrideUserInterfaceStyle = style
		Preferences.preferredInterfaceStyle = style.rawValue
	}
}

extension DisplayViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int { return sectionTitles.count }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableData[section].count }
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionTitles[section] }
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return sectionTitles[section].isEmpty ? 5 : 40 }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = sectionTitles[section]
		let headerView = CustomSectionHeader(title: title)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let reuseIdentifier = "Cell"
		let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		cell.selectionStyle = .none
		
		let cellText = tableData[indexPath.section][indexPath.row]
		
		switch cellText {
		case "Appearence":
			cell.textLabel?.text = "Appearence"
			let cfg = UIButton.Configuration.plain()
			let appearanceButton = UIButton(configuration: cfg)
			
			appearanceButton.setTitle(UIUserInterfaceStyle(rawValue: Preferences.preferredInterfaceStyle)?.description, for: .normal)
			
			let appearanceMenuItems: [UIAction] = UIUserInterfaceStyle.allCases.map { style in
				UIAction(title: style.description, state: (style.rawValue == Preferences.preferredInterfaceStyle) ? .on : .off) { [weak self] action in
					self?.updateAppearance(with: style)
					appearanceButton.setTitle(style.description, for: .normal)
				}
			}
			
			let appearanceMenu = UIMenu(options: [.singleSelection], children: appearanceMenuItems)
			
			appearanceButton.menu = appearanceMenu
			appearanceButton.showsMenuAsPrimaryAction = true
			
			if let detailTextColor = cell.detailTextLabel?.textColor {
				appearanceButton.setTitleColor(detailTextColor, for: .normal)
				appearanceButton.tintColor = .tertiaryLabel
			}
			cell.contentView.addSubview(appearanceButton)
			
			appearanceButton.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				appearanceButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4),
				appearanceButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
			])
			
		case "Collection View":
			let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
			cell.setData(collectionData: collectionData, colors: collectionDataColors)
			cell.backgroundColor = .clear
			return cell
		default:
			break
		}
		return cell
	}
}
