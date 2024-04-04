//
//  SettingsViewController.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import UIKit
import Nuke

class SettingsViewController: UIViewController {

    var tableView: UITableView!

    var tableData: [[String]] {
        return [
            ["Display", "Languages"],
            ["Licenses", "GitHub Repository", "Support via Ko-Fi"],
            ["Clear Network Cache", "Reset Settings"]
        ]
    }
	
    var sectionTitles: [String] {
        return [
            "",
            "About",
            "Advanced"
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    fileprivate func setupViews() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.backgroundColor = UIColor(named: "Background")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
        self.tableView.constraintCompletely(to: view)
    }
    
    fileprivate func setupNavigation() {
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .default
        cell.accessoryType = .none
        
        let cellText = tableData[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellText
        
        switch cellText {
        case 
			"Display",
			"Languages",
			"Licenses":
            cell.accessoryType = .disclosureIndicator
        case
            "GitHub Repository",
            "Support via Ko-Fi":
			cell.textLabel?.textColor = UIColor.tintColor
            Append().accessoryIcon(to: cell, with: "safari")
			
        // Advanced
        case
			"Clear Network Cache":
			cell.textLabel?.textColor = UIColor.tintColor
        case "Reset Settings":
            cell.textLabel?.textColor = UIColor.systemRed
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellText = tableData[indexPath.section][indexPath.row]
        switch cellText {
        case "Display":
			let d = DisplayViewController()
			navigationController?.pushViewController(d, animated: true)
        
        case "Licenses":
            let l = LicensesViewController()
            navigationController?.pushViewController(l, animated: true)
            
        // Advanced
        case "Clear Network Cache":
            var totalCacheSize = URLCache.shared.currentDiskUsage
            if let nukeCache = ImagePipeline.shared.configuration.dataCache as? DataCache {
                totalCacheSize += nukeCache.totalSize
            }
            let message = "This action is irreversible. Cached network requests and images will be cleared."
            + "\n\n"
            + String("Cache size: \(ByteCountFormatter.string(fromByteCount: Int64(totalCacheSize), countStyle: .file))")
            
            confirmAction(
                title: "Clear Network Cache",
                message: message
            ) {
                self.clearNetworkCache()
            }
            
        case "Reset Settings":
            confirmAction(
                title: "Reset Settings",
                message: "This action is irreversible. All app and settings will be reset."
            ) {
                self.resetSettings()
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func confirmAction(
        title: String,
        message: String,
        continueActionName: String = "Continue",
        destructive: Bool = true,
        proceed: @escaping () -> Void
    ) {
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )

        let action = UIAlertAction(title: continueActionName, style: destructive ? .destructive : .default) { _ in proceed() }
        alertView.addAction(action)

        alertView.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        present(alertView, animated: true)
    }

}



// MARK: - Data Clearing Methods
extension SettingsViewController {

    func clearNetworkCache() {
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        if let dataCache = ImagePipeline.shared.configuration.dataCache as? DataCache {
            dataCache.removeAll()
        }
        
        if let imageCache = ImagePipeline.shared.configuration.imageCache as? Nuke.ImageCache {
            imageCache.removeAll()
        }
    }

    func resetSettings() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}

//        let headerView = AboutHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
//        self.tableView.tableHeaderView = headerView
