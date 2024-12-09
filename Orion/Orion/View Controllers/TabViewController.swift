import UIKit
import WebKit

protocol PageControlSwipe: AnyObject {
    func goToNextPage()
    func goToPreviousPage()
}

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    var page: TabPage?
    weak var delegate: PageControlSwipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = page?.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    @IBAction func goRight(_ sender: UIButton) {
        delegate?.goToNextPage()
    }
    
    @IBAction func goLeft(_ sender: UIButton) {
        delegate?.goToPreviousPage()
    }
}

