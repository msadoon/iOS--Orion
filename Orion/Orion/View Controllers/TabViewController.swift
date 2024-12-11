import UIKit
import WebKit

protocol PageControlSwipe: AnyObject {
    func go(direction: UIPageViewController.NavigationDirection)
}

class TabViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textEntryView: UITextField!
    @IBOutlet weak var contentView: UIView!
    var page: TabPage?
    weak var delegate: PageControlSwipe?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContentView()
        self.setupWebView()
        self.setupTextEntry()
    }
    
    // MARK: Setup
    private func setupContentView() {
        NSLayoutConstraint.activate([self.contentView.bottomAnchor.constraint(equalTo:
                                                                                view.keyboardLayoutGuide.topAnchor)])
    }
    
    private func setupTextEntry() {
        self.textEntryView.delegate = self
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
        self.view.endEditing(false)
        
        guard let urlRequest = updateURL(from: textField.text) else {
            return true
        }
        
        textField.text = urlRequest.url?.absoluteString
        
        self.webView.load(urlRequest)
        
        return true
    }
    
    private func updateURL(from rawText: String?) -> URLRequest? {
        guard let urlTextValue = rawText,
              let urlComponents = URLComponents(string: urlTextValue),
              let unformattedURLValue = urlComponents.url else { return nil }
        
        var urlRequest: URLRequest?
        
        if let scheme = urlComponents.scheme,
           let _ = SupportedSchemes(rawValue: scheme),
           let urlValue = URL(string: unformattedURLValue.formatted(.url.locale(.current)))  {
            urlRequest = URLRequest(url: urlValue)
        } else if let unformattedURL = URL(string: SupportedSchemes.https.rawValue + SupportedSchemes.schemaFragment.rawValue +  unformattedURLValue.absoluteString),
                  let urlValue = URL(string: unformattedURL.formatted(.url.locale(.current))) {
            urlRequest = URLRequest(url: urlValue)
        }
        
        guard let urlRequestWithScheme = urlRequest else { return nil }
        
        return urlRequestWithScheme
    }
}
