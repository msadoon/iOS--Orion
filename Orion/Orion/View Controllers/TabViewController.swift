import UIKit
import WebKit

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var page: TabPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = page?.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

