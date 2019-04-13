//
//  DocumentsInputViewController.swift
//  tm
//
//  Created by i834123 on 4/12/19.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation
import UIKit

struct Doc: Decodable {
  let tsdrStatusUrl: String
  let tsdrImageOriginal: String
}

struct Response: Decodable {
  let docs: [Doc]
  let numFound: Int
  let start: Int
}

struct Documents: Decodable {
  let response: Response
}

class DocumentsInputViewController: UIViewController {

  @IBOutlet weak var textTextField: UITextField!
  @IBOutlet weak var runButton: UIButton!
  @IBOutlet weak var runningSpinner: UIActivityIndicatorView!
  @IBOutlet weak var resultsButton: UIButton!

  var response: Response?

  override func viewDidLoad() {
    self.textTextField.text = "Mickey Mouse"
  }

  func success(_ count: Int) {
    DispatchQueue.main.async {
      self.runningSpinner.isHidden = true
      self.resultsButton.setTitle("\(count) >", for: .normal)
      self.resultsButton.isHidden = false
    }
  }

  func failure() {
    DispatchQueue.main.async {
      self.runningSpinner.isHidden = true
      self.resultsButton.setTitle("⛔️", for: .normal)
      self.resultsButton.isHidden = false
    }
  }

  @IBAction func run(_ sender: Any) {

    runButton.isHidden = true
    runningSpinner.isHidden = false

    let request = APIRequest(method: .get, path: "documents")

    request.queryItems.append(URLQueryItem(name: "text", value: textTextField.text!))

    APIClient().perform(request) { (result) in
      switch result {
      case .success(let response):
        if let documentsResponse = try? response.decode(to: Documents.self) {
          self.response = documentsResponse.body.response
          self.success(documentsResponse.body.response.numFound)
        } else {
          self.failure()
        }
      case .failure:
        self.failure()
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let navVC = segue.destination as? UINavigationController,
      let topVC = navVC.topViewController as? DocumentsViewController {
      topVC.response = response
    }
  }
}
