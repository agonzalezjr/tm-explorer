//
//  DocumentsViewController.swift
//  tm
//
//  Created by i834123 on 4/13/19.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DocumentsViewController: UITableViewController {

  var response: Response?

  override func viewDidLoad() {
    print("foo")
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.response?.numFound ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "markCell", for: indexPath)
    let imageView = cell.contentView.viewWithTag(12345) as! UIImageView

    let url = URL(string: (self.response?.docs[indexPath.row].tsdrImageOriginal)!)
    imageView.kf.setImage(with: url)

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
}
