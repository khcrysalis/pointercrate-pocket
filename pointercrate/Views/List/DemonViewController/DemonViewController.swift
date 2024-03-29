//
//  DemonViewController.swift
//  pointercrate
//
//  Created by samara on 3/26/24.
//

import UIKit

class DemonViewController: UIViewController {
	var tableView: UITableView!
	
	private var activityIndicator: UIActivityIndicatorView!
	private var records: DemonResponse?
	
	private var headerImageView: UIImageView?
	var myHeaderView: UIView!
	var stickyHeaderController: HeaderController!
	
	var sectionTitles: [String] {
		return ["Records", ""]
	}
	
	var demonID: Int? {
		didSet {
			if let demonID = demonID {
				print("Demon ID set to: \(demonID)")
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupHeader()
		loadDemon()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		let defaultAppearance = UINavigationBarAppearance()
		self.navigationController?.navigationBar.standardAppearance = defaultAppearance
		self.navigationController?.navigationBar.scrollEdgeAppearance = defaultAppearance
		self.navigationController?.navigationBar.compactAppearance = defaultAppearance
		self.navigationController?.navigationBar.tintColor = .tintColor
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
		
		self.activityIndicator = UIActivityIndicatorView(style: .large)
		self.activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y + 100)
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.startAnimating()
		self.view.addSubview(activityIndicator)
	}
	
	fileprivate func setupHeader() {
		self.myHeaderView = UIView()
		
		let placeholderImageView = UIImageView(image: UIImage())
		placeholderImageView.contentMode = .scaleAspectFill
		self.myHeaderView.addSubview(placeholderImageView)
		placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			placeholderImageView.leadingAnchor.constraint(equalTo: self.myHeaderView.leadingAnchor),
			placeholderImageView.trailingAnchor.constraint(equalTo: self.myHeaderView.trailingAnchor),
			placeholderImageView.topAnchor.constraint(equalTo: self.myHeaderView.topAnchor),
			placeholderImageView.bottomAnchor.constraint(equalTo: self.myHeaderView.bottomAnchor)
		])
		
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.myHeaderView.addSubview(blurEffectView)
		NSLayoutConstraint.activate([
			blurEffectView.leadingAnchor.constraint(equalTo: self.myHeaderView.leadingAnchor),
			blurEffectView.trailingAnchor.constraint(equalTo: self.myHeaderView.trailingAnchor),
			blurEffectView.topAnchor.constraint(equalTo: self.myHeaderView.topAnchor),
			blurEffectView.bottomAnchor.constraint(equalTo: self.myHeaderView.bottomAnchor)
		])
		self.myHeaderView.sendSubviewToBack(placeholderImageView)
		
		self.headerImageView = placeholderImageView
		self.stickyHeaderController = HeaderController(view: myHeaderView, height: 300)
		self.stickyHeaderController.attach(to: tableView)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.stickyHeaderController.layoutStickyView()
		
		let start: CGFloat = -160
		let length: CGFloat = 30
		
		if tableView.contentOffset.y < start {
			self.navigationController?.navigationBar.tintColor = UIColor.white
			let appearance = UINavigationBarAppearance()
			appearance.configureWithTransparentBackground()
			appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0)
			navigationController?.navigationBar.standardAppearance = appearance
			navigationController?.navigationBar.scrollEdgeAppearance = appearance
			navigationController?.navigationBar.compactAppearance = appearance
		} else if tableView.contentOffset.y > start && tableView.contentOffset.y < length + start {
			let alpha = (tableView.contentOffset.y - start) / length
			let interpolatedColor = UIColor.interpolate(from: .white, to: .tintColor, with: alpha)
			self.navigationController?.navigationBar.tintColor = interpolatedColor
		} else if tableView.contentOffset.y >= length + start {
			self.navigationController?.navigationBar.tintColor = .tintColor
			let defaultAppearance = UINavigationBarAppearance()
			navigationController?.navigationBar.standardAppearance = defaultAppearance
			navigationController?.navigationBar.scrollEdgeAppearance = defaultAppearance
			navigationController?.navigationBar.compactAppearance = defaultAppearance
		}
	}
}

extension DemonViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return sectionTitles[section].isEmpty ? 5 : 60 }
	func numberOfSections(in tableView: UITableView) -> Int { return sectionTitles.count }
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = sectionTitles[section]
		let headerView = CustomSectionHeader(title: title, topAnchorConstant: 27)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return records != nil ? 1 : 0
		case 1:
			return records?.data.records?.count ?? 0
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
		
		switch indexPath.section {
		case 0:
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.lineBreakMode = .byWordWrapping
			
			let totalRecordsCount = records?.data.records?.count ?? 0
			let hundredPercentRecordsCount = records?.data.records?.filter { $0.progress == 100 }.count ?? 0
			
			cell.textLabel?.text = "\(records?.data.requirement ?? 0)% or better to qualify"
			cell.detailTextLabel?.text = "\(totalRecordsCount) records registered, out of which \(hundredPercentRecordsCount) are 100%"
			cell.detailTextLabel?.textColor = .secondaryLabel
		case 1:
			let recordIndex = indexPath.row
			if let record = records?.data.records?[recordIndex] {
				let countryCode = record.nationality?.country_code
				let flagEmoji = flag(country: countryCode)
				cell.textLabel?.text = flagEmoji + record.player.name
				cell.detailTextLabel?.text = "\(record.progress)%"
			}
		default:
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func flag(country: String?) -> String {
		guard let countryCode = country else { return "" }
		let base: UInt32 = 127397
		var s = ""
		for v in countryCode.unicodeScalars { s.unicodeScalars.append(UnicodeScalar(base + v.value)!) }
		return String(s) + "  "
	}
}

extension DemonViewController {
	func loadDemon() {
		Task {
			do {
				self.records = try await PointercrateAPI.shared.getDemon(id: demonID!)
				
				if let thumbnailURLString = self.records?.data.thumbnail,
				   let thumbnailURL = URL(string: thumbnailURLString),
				   let imageData = try? Data(contentsOf: thumbnailURL) {
					let image = UIImage(data: imageData)
					DispatchQueue.main.async {
						UIView.transition(with: self.headerImageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
							let title = self.records?.data.name ?? ""
							let subtitle = "By \(self.records?.data.publisher.name ?? ""), verified by \(self.records?.data.verifier.name ?? "")"
							
							self.stickyHeaderController.updateTitle(title)
							self.stickyHeaderController.updateSubtitle(subtitle)
							self.stickyHeaderController.layoutStickyView()
							self.headerImageView?.image = image
							
						}, completion: nil)
					}
				}
				
				DispatchQueue.main.async {
					UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
						self.tableView.reloadData()
						self.activityIndicator.stopAnimating()
					}, completion: nil)
				}
				
			} catch {
				print("Error fetching demons: \(error)")
				DispatchQueue.main.async {
					self.tableView.reloadData()
					self.activityIndicator.stopAnimating()
				}
			}
		}
	}
	
}
