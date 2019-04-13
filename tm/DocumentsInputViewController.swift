//
//  DocumentsInputViewController.swift
//  tm
//
//  Created by i834123 on 4/12/19.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation
import UIKit

class DocumentsInputViewController: UIViewController {

  @IBOutlet weak var textTextField: UITextField!
  @IBOutlet weak var runButton: UIButton!
  @IBOutlet weak var runningSpinner: UIActivityIndicatorView!
  @IBOutlet weak var resultLabel: UILabel!

  override func viewDidLoad() {
    self.textTextField.text = "Mickey Mouse"
  }

  func success(_ count: Int) {
    DispatchQueue.main.async {
      self.runningSpinner.isHidden = true
      self.resultLabel.text = "\(count) >"
      self.resultLabel.isHidden = false
    }
  }

  func failure() {
    DispatchQueue.main.async {
      self.runningSpinner.isHidden = true
      self.resultLabel.text = "⛔️"
      self.resultLabel.isHidden = false
    }
  }

  struct Doc: Decodable {
    let tsdrStatusUrl: String
  }

  struct Response: Decodable {
    let docs: [Doc]
    let numFound: Int
    let start: Int
  }

  struct Documents: Decodable {
    let response: Response
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
          self.success(documentsResponse.body.response.numFound)
        } else {
          self.failure()
        }
      case .failure:
        self.failure()
      }
    }
  }
}
