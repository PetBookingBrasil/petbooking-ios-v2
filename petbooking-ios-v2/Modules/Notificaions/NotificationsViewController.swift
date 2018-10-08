//
//  NotificationsViewController.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, NotificationsViewProtocol {

  @IBOutlet weak var tableView: UITableView!

  weak var presenter: NotificationsPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackButton()
    setupUI()

    self.title = "Notificações"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func setupUI() {
    addBarButtonItems()
    setupTableView()
  }

  private func addBarButtonItems() {
    let addButton = UIBarButtonItem(title: "Limpar", style: .plain, target: self, action: #selector(clearButon))

    self.navigationItem.rightBarButtonItems = [addButton]
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 145.0
  }

  @objc private func clearButon() {
    // TODO:
  }
}

extension NotificationsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)
    if let notificationCell = cell as? NotificationTableViewCell {
      // TODO:
    }
    return cell
  }
}

extension NotificationsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 145.0
  }
}
