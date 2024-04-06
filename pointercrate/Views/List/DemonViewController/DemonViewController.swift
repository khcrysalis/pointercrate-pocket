//
//  DemonViewController.swift
//  pointercrate
//
//  Created by samara on 3/26/24.
//

import UIKit
extension UIImage.SymbolConfiguration {
	static let navigationBarItem = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
}
class DemonViewController: UIViewController {
	var tableView: UITableView!
	
	private var activityIndicator: UIActivityIndicatorView!
	private var records: DemonResponse?
	
	private var headerImageView: UIImageView?
	private var headerView: UIView!
	private var stickyHeaderController: HeaderController!
	
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
		//self.navigationController?.navigationBar.tintColor = UIColor.tintColor
	}
	
	func setupNavigation() {
		var config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
		config = config.applying(UIImage.SymbolConfiguration(paletteColors: [.darkGray, .white]))

		let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill", withConfiguration: config), style: .plain, target: self, action: #selector(backToMain))
		
		navigationItem.leftBarButtonItem = backButton
	}
	
	@objc func backToMain() {
		self.navigationController?.popViewController(animated: true)
	}
	
	fileprivate func setupViews() {
		self.tableView = UITableView(frame: .zero, style: .insetGrouped)
		self.tableView.isHidden = true
		self.view.backgroundColor = UIColor(named: "Background")
		self.tableView.backgroundColor = UIColor(named: "Background")
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		self.view.addSubview(tableView)
		self.tableView.constraintCompletely(to: view)
		self.tableView.setLayoutMargins(UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
		
		self.activityIndicator = UIActivityIndicatorView(style: .medium)
		self.activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.startAnimating()
		self.view.addSubview(activityIndicator)
	}
	
	fileprivate func setupHeader() {
		self.headerView = UIView()
		self.headerView.isHidden = true
		
		let placeholderImageView = UIImageView(image: UIImage(named: "defaultthumbnail"))
		placeholderImageView.contentMode = .scaleAspectFill
		self.headerView.addSubview(placeholderImageView)
		placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			placeholderImageView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
			placeholderImageView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
			placeholderImageView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
			placeholderImageView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor)
		])

		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.frame = placeholderImageView.bounds
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		self.headerView.layer.addSublayer(gradientLayer)
		
		let gradientMask = VariableBlurViewConstants.defaultGradientMask
		let variableBlurView = UIVariableBlurView(frame: .zero)
		variableBlurView.translatesAutoresizingMaskIntoConstraints = false
		variableBlurView.gradientMask = gradientMask
		self.headerView.addSubview(variableBlurView)
		
		NSLayoutConstraint.activate([
			variableBlurView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
			variableBlurView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
			variableBlurView.topAnchor.constraint(equalTo: self.headerView.centerYAnchor),
			variableBlurView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor)
		])
		self.headerView.sendSubviewToBack(placeholderImageView)
		variableBlurView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		
		self.headerImageView = placeholderImageView
		self.stickyHeaderController = HeaderController(view: headerView, height: 250)
		self.stickyHeaderController.attach(to: tableView)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.stickyHeaderController.layoutStickyView()
		
		let threshold: CGFloat = -330
		
		if scrollView.contentOffset.y > threshold {
			navigationItem.leftBarButtonItem = nil
		} else {
			setupNavigation()
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
				Append().accessoryIcon(to: cell, with: "arrow.up.right")
			}
		default:
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let records = records, indexPath.section == 1, let record = records.data.records?[indexPath.row], let videoURLString = record.video, let videoURL = URL(string: videoURLString) else {
			return
		}
		
		UIApplication.shared.open(videoURL)
	}

	
	func flag(country: String?) -> String {
		guard let countryCode = country else { return "" }
		let base: UInt32 = 127397
		var s = ""
		for v in countryCode.unicodeScalars { s.unicodeScalars.append(UnicodeScalar(base + v.value)!) }
		return String(s) + "  "
	}
	
	func calculateScore(progress: Double) -> String {
		let positionValue = self.records?.data.position ?? 0
		let position = Int16(positionValue)
		let requirementValue = self.records?.data.requirement ?? 0
		let requirement = Int16(requirementValue)
		let maxpoints = score(progress: Int16(progress), position: Double(position), requirement: requirement)
		return "\(maxpoints)"
	}
}

extension DemonViewController {
	func loadDemon() {
		Task {
			do {
				self.records = try await PointercrateAPI.shared.getDemon(id: demonID!)
				


				
				if let thumbnailURLString = convertToMaxDefaultThumbnailURL(from: (self.records?.data.thumbnail)!),
				   
				   let thumbnailURL = URL(string: thumbnailURLString),
				   let imageData = try? Data(contentsOf: thumbnailURL) {
					let image = UIImage(data: imageData)
					DispatchQueue.main.async {
						UIView.transition(with: self.headerImageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
							self.stickyHeaderController?.updateButtonsatt(
								position: "\(self.records?.data.position ?? 0)",
								video: self.records?.data.video ?? "",
								maxpoints: self.calculateScore(progress: 100),
								minpoints: self.calculateScore(progress: Double((self.records?.data.requirement)!))
							)
							
							
							
							
							self.stickyHeaderController.updateTitle(self.records?.data.name ?? "")
							self.stickyHeaderController.updateSubtitle("By \(self.records?.data.publisher.name ?? ""), verified by \(self.records?.data.verifier.name ?? "")")
							self.stickyHeaderController.layoutStickyView()
							self.headerView.isHidden = false
							self.tableView.isHidden = false
							self.headerImageView?.image = image
						}, completion: nil)
					}
				} else {
					DispatchQueue.main.async {
						self.stickyHeaderController?.updateButtonsatt(
							position: "\(self.records?.data.position ?? 0)",
							video: self.records?.data.video ?? "",
							maxpoints: self.calculateScore(progress: 100),
							minpoints: self.calculateScore(progress: Double((self.records?.data.requirement)!))
						)
						self.stickyHeaderController.updateTitle(self.records?.data.name ?? "")
						self.stickyHeaderController.updateSubtitle("By \(self.records?.data.publisher.name ?? ""), verified by \(self.records?.data.verifier.name ?? "")")
						self.stickyHeaderController.layoutStickyView()
						self.headerView.isHidden = false
						self.tableView.isHidden = false
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
