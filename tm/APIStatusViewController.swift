
import Foundation
import UIKit

class APIStatusViewController: UIViewController {

  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var runButton: UIButton!
  @IBOutlet weak var runningSpinner: UIActivityIndicatorView!

  override func viewWillAppear(_ animated: Bool) {
    runningSpinner.isHidden = true
    resultLabel.isHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  func success() {
    DispatchQueue.main.async {
      self.runningSpinner.isHidden = true
      self.resultLabel.text = "✅"
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

  @IBAction func run(_ sender: Any) {

    runButton.isHidden = true
    runningSpinner.isHidden = false

    let request = APIRequest(method: .get, path: "apistatus")

    APIClient().perform(request) { (result) in
      switch result {
      case .success(let response):
        switch response.statusCode {
        case 200:
          print("OK")
          self.success()
        default:
          print("ERROR")
          self.failure()
        }
      case .failure:
        print("ERROR - NW")
        self.failure()
      }
    }


  }
}
