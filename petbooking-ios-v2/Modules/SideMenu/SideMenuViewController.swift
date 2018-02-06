//
//  SideMenuViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 18/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class SideMenuViewController: UIViewController, SideMenuViewProtocol {
    
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	@IBOutlet weak var profilePanelView: UIView!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var menuTableView: UITableView!
	
	var menuItens:[SideMenuItem] = [.myPets, .search, .agenda, .favorites, .logout]
	
	var presenter: SideMenuPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		setupUserData()
		navigationController?.isNavigationBarHidden = true
		
		menuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
		menuTableView.delegate = self
		menuTableView.dataSource = self
		
		self.profileImageView.round()
    }
	
	func setupUserData() {
		guard let user = UserManager.sharedInstance.getCurrentUser() else { return }
		
		nameLabel.text = user.name
		emailLabel.text = user.email
		if user.gender == "male" {
			self.profileImageView.image = UIImage(named:"avatar-padrao-m")
		} else {
			self.profileImageView.image = UIImage(named:"avatar-padrao-f")
		}
		
		if user.avatarUrlThumb.contains("http") {
			if let url = URL(string: user.avatarUrlThumb) {
				self.profileImageView.pin_setImage(from: url)
			}
		} else {
			if let url = URL(string: "https://cdn.petbooking.com.br/\(user.avatarUrlThumb)") {
				self.profileImageView.pin_setImage(from: url)
			}
		}
	}

	@IBAction func didTapProfileButton(_ sender: Any) {
		presenter?.didTapProfile()
	}
	
	@IBAction func goToProfile(_ sender: Any) {
		presenter?.didTapProfile()
	}
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItens.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuTableViewCell
		
		let sideMenuItem = menuItens[indexPath.row]
		
		switch sideMenuItem {
		case .myPets:
			cell.iconImageView.image = UIImage(named:"pet")
			cell.titleLabel.text = NSLocalizedString("side_menu_my_pets", comment: "")
			break
		case .search:
			cell.iconImageView.image = UIImage(named:"search")
			cell.titleLabel.text = NSLocalizedString("side_menu_search", comment: "")
			break
		case .agenda:
			cell.iconImageView.image = UIImage(named:"agenda")
			cell.titleLabel.text = NSLocalizedString("side_menu_agenda", comment: "")
			break
		case .payments:
			cell.iconImageView.image = UIImage(named:"payments")
			cell.titleLabel.text = NSLocalizedString("side_menu_payments", comment: "")
			break
		case .favorites:
			cell.iconImageView.image = UIImage(named:"favorites")
			cell.titleLabel.text = NSLocalizedString("side_menu_favorites", comment: "")
			break
		case .settings:
			cell.iconImageView.image = UIImage(named:"settings")
			cell.titleLabel.text = NSLocalizedString("side_menu_settings", comment: "")
			break
		case .logout:
			cell.iconImageView.image = UIImage(named:"logout")
			cell.titleLabel.text = NSLocalizedString("side_menu_logout", comment: "")
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
		selectedCell.contentView.backgroundColor = UIColor(hex: "e94040")
		
		let sideMenuItem = menuItens[indexPath.row]
		
		switch sideMenuItem {
		case .myPets:
			presenter?.didTapMyPets()
					break
		case .search:
			presenter?.didTapSearch()
					break
		case .agenda:
			presenter?.didTapAgenda()
			break
		case .payments:
			break
		case .favorites:
			presenter?.didTapFavorites()
			break
		case .settings:
			break
		case .logout:
			presenter?.didTapLogout()
					break
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
		selectedCell.contentView.backgroundColor = UIColor(hex: "E4002B")
	}
}

extension Notification.Name {
	static let goToAgenda = Notification.Name("goToAgenda")
}
