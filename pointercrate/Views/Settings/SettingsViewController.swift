//
//  SettingsViewController.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import UIKit
import Nuke

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
//    var myHeaderView: UIView!
//    var stickyHeaderController: HeaderController!
//    
//    fileprivate var titleView: UIView!
//    fileprivate var iconView: UIImageView!

    var tableData: [[String]] {
        return [
            ["Uhmm!!!!"],
            ["Licenses", "GitHub Repository", "Support via Ko-Fi"],
            ["GET", "Clear Network Cache", "Reset Settings"]
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
    
    // suck my ass
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
    
//        self.myHeaderView = UIView()
//        let backgroundImage = UIImage(named: "bg")
//        let backgroundImageView = UIImageView(image: backgroundImage)
//        backgroundImageView.contentMode = .scaleAspectFill
//        self.myHeaderView.addSubview(backgroundImageView)
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            backgroundImageView.leadingAnchor.constraint(equalTo: self.myHeaderView.leadingAnchor),
//            backgroundImageView.trailingAnchor.constraint(equalTo: self.myHeaderView.trailingAnchor),
//            backgroundImageView.topAnchor.constraint(equalTo: self.myHeaderView.topAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: self.myHeaderView.bottomAnchor)
//        ])
//        self.stickyHeaderController = HeaderController(view: myHeaderView, height: 300)
//        self.stickyHeaderController.attach(to: tableView)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
        self.tableView.constraintCompletely(to: view)
    }
    
    fileprivate func setupNavigation() {
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.title = nil
//        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "E1201B")
//        
//        self.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 29))
//        self.iconView = UIImageView(frame: self.titleView.bounds)
//
//        if let appIconImage = UIImage(named: "AppIcon") {
//            iconView.image = appIconImage
//            iconView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            
//            iconView.layer.cornerRadius = iconView.bounds.width / 5
//            iconView.clipsToBounds = true
//            
//            iconView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
//            iconView.layer.borderWidth = 1
//        }
//
//        self.iconView.alpha = 0
//        self.titleView.addSubview(iconView)
//
//        self.navigationItem.titleView = titleView
    }

    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.tintColor = nil
//        self.navigationController?.navigationBar.barTintColor = nil
//        self.navigationItem.titleView = nil
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.stickyHeaderController.layoutStickyView()
//        
//        let start: CGFloat = -60
//        let length: CGFloat = 50
//        
//        guard let iconView = self.iconView else {
//            return
//        }
//        
//        if tableView.contentOffset.y < start {
//            iconView.alpha = 0
//        } else if tableView.contentOffset.y > start && tableView.contentOffset.y < length + start {
//            iconView.alpha = (tableView.contentOffset.y - start) / length
//        } else if tableView.contentOffset.y >= length + start {
//            iconView.alpha = 1
//        }
//    }
}
// MARK: - TableView
extension SettingsViewController {
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

        //
        case "Licenses":
            cell.accessoryType = .disclosureIndicator
        case
            "GitHub Repository",
            "Support via Ko-Fi":
            cell.textLabel?.textColor = UIColor.tintColor
            Append().accessoryIcon(to: cell, with: "safari")
        // Advanced
        case "Clear Network Cache":
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
        case "GET":
			Preferences.isOnboardingActive = true
        case "Uhmm!!!!":
            break
        //
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
