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

  @IBAction func runTapped(_ sender: Any) {
    print("run (input = \(textTextField.text))")
  }
}
