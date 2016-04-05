import UIKit
import WebKit

class AcknowledgementsViewController: UIViewController {
    var webView: WKWebView {
        return view as! WKWebView
    }
}

// MARK: UIViewController
extension AcknowledgementsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .Plain, target: self, action: "didTapBackButton:")
        webView.loadHTMLString(acknowledgementsHTMLString(), baseURL: nil)
    }

    override func loadView() {
        view = WKWebView(frame: CGRectZero)
    }
}

// MARK: Actions
extension AcknowledgementsViewController {
    func didTapBackButton(_: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Private methods
private extension AcknowledgementsViewController {
    func acknowledgementsHTMLString() -> String {
        guard
            let file = NSBundle.mainBundle().pathForResource("Acknowledgements", ofType:"html"),
            let data = NSData(contentsOfFile: file),
            let htmlString = String(data: data, encoding: NSUTF8StringEncoding)
        else {
            return ""
        }
        return htmlString
    }
}
