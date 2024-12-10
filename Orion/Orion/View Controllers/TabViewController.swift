import UIKit
import WebKit

protocol PageControlSwipe: AnyObject {
    func go(direction: UIPageViewController.NavigationDirection)
}

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    var page: TabPage?
    weak var delegate: PageControlSwipe?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContentView()
        self.setupWebView()
        self.urlTextField.delegate = self
    }
    
    // MARK: Setup
    private func setupContentView() {
        NSLayoutConstraint.activate([self.contentView.bottomAnchor.constraint(equalTo:
                                                                            view.keyboardLayoutGuide.topAnchor)])
    }
    
    private func setupWebView() {
        guard let url = page?.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    // MARK: IBActions
    @IBAction func goToNextPage(_ sender: UISwipeGestureRecognizer) {
        transition(using: sender, direction: .forward)
    }
    
    @IBAction func goToPreviousPage(_ sender: UISwipeGestureRecognizer) {
        transition(using: sender, direction: .reverse)
    }

    // MARK: Helpers
    private func transition(using sender: UISwipeGestureRecognizer, direction: UIPageViewController.NavigationDirection) {
        switch sender.state {
        case .ended:
            delegate?.go(direction: direction)
        default:
            break
        }
    }
}

extension TabViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
}
