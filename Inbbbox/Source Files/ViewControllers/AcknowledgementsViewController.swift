import UIKit

class AcknowledgementsViewController: UIViewController {
}

// MARK: UIViewController
extension AcknowledgementsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "didTapBackButton:")
    }
}

// MARK: Actions
extension AcknowledgementsViewController {

    func didTapBackButton(_: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
