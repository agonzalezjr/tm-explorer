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

    DispatchQueue.global().async {
      let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
      DispatchQueue.main.async {
        imageView.image = UIImage(data: data!)
      }
    }

    return cell
  }
}
