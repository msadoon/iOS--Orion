import UIKit
import WebKit

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var rawURLValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let value = rawURLValue else { return }
        
        webView.load(URLRequest(url: URL(string: value)!))
    }
}

