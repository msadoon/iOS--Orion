import UIKit
import WebKit

protocol PageControlSwipe: AnyObject {
    func go(direction: UIPageViewController.NavigationDirection)
}

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var page: TabPage?
    weak var delegate: PageControlSwipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = page?.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    @IBAction func goToNextPage(_ sender: UISwipeGestureRecognizer) {
        transition(using: sender, direction: .forward)
    }
    
    @IBAction func goToPreviousPage(_ sender: UISwipeGestureRecognizer) {
        transition(using: sender, direction: .reverse)
    }
    
    private func transition(using sender: UISwipeGestureRecognizer, direction: UIPageViewController.NavigationDirection) {
        switch sender.state {
        case .ended:
            delegate?.go(direction: direction)
        default:
            break
        }
    }
}

