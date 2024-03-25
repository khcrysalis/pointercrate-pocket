//
//  APIAboutViewController.swift
//  pointercrate
//
//  Created by samara on 3/23/24.
//

import UIKit

class APIAboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    private var sourceTitle: String?
    private var sourceWebsite: String?
    private var sourceIcon: UIImage = UIImage(named: "unknown")!
    private var cellWebsite: URL?
    private var cellDocumentation: URL?
    private var textColor: UIColor = .label

    var tableData: [[String]] {
        return [
            ["Source"],
            ["Website", "Documentation"]
        ]
    }
    
    var sectionTitles: [String] {
        return [
            "Source",
            "Info",
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setTableValues()
        self.setupViews()
    }
    
    func setTableValues() {
        sourceTitle = "Pointercrate"
        sourceWebsite = "pointercrate.com"
        sourceIcon = UIImage(named: "Demon List Icon")!
        cellWebsite = URL(string: "https://pointercrate.com")
        cellDocumentation = URL(string: "https://pointercrate.com/documentation/index")
        textColor = .systemRed
    }

    fileprivate func setupViews() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
        self.tableView.constraintCompletely(to: view)
        self.tableView.setLayoutMargins(UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(closeSheet))
    }
    
    @objc func closeSheet() {
        dismiss(animated: true, completion: nil)
    }
}

extension APIAboutViewController {
    func numberOfSections(in tableView: UITableView) -> Int { return sectionTitles.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableData[section].count }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionTitles[section] }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return sectionTitles[section].isEmpty ? 5 : 40 }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return
"""
This application is not affiliated with any of the sources where their REST APIs are used.
"""
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 80
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sectionTitles[section]
        let headerView = CustomSectionHeader(title: title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .default
        cell.accessoryType = .none
        
        let cellText = tableData[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellText
        switch cellText {
        case "Source":
            cell.textLabel?.text = sourceTitle
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.text = sourceWebsite
            cell.detailTextLabel?.textColor = .secondaryLabel
            cell.selectionStyle = .none
            SectionIcons.sectionImage(to: cell, with: sourceIcon)
        case
            "Documentation",
            "Website":
            cell.textLabel?.textColor = textColor
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellText = tableData[indexPath.section][indexPath.row]
        switch cellText {
        case "Documentation":
            UIApplication.shared.open(cellDocumentation!, options: [:], completionHandler: nil)
        case "Website":
            UIApplication.shared.open(cellWebsite!, options: [:], completionHandler: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
