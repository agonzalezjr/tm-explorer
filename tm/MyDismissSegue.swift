
import Foundation
import UIKit

class MyDismissSegue: UIStoryboardSegue {
  override func perform() {
    self.source.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
