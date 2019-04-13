//
//  DocumentsViewController.swift
//  tm
//
//  Created by i834123 on 4/13/19.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation
import UIKit

class DocumentsViewController: UITableViewController {

  override func viewDidLoad() {
    print("foo")
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
}
