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
        
        guard let refreshImage = UIImage(systemName: Images.refresh.rawValue) else { return }
        
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(origin: .zero,
                                     size: .init(width: refreshImage.size.width,
                                              height: refreshImage.size.height))
        let refreshView = UIView(frame: CGRect(origin: .zero,
                                            size: .init(width: refreshButton.frame.size.width + Padding.thin.rawValue,
                                                     height: refreshButton.frame.size.height)))
        
        refreshButton.setImage(refreshImage, for: .normal)
        
        refreshButton.contentMode = .center
        
        refreshButton.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        refreshView.addSubview(refreshButton)
        
        self.textEntryView.rightViewMode = .always
        self.textEntryView.rightView = refreshView
    }
    
    @objc private func refreshPage() {
        guard let urlRequest = updateURL(from: self.textEntryView.text, reloadFromCache: false) else { return }
        
        self.webView.load(urlRequest)
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
        
        guard let urlRequest = updateURL(from: textField.text, reloadFromCache: true) else {
            return true
        }
        
        textField.text = urlRequest.url?.absoluteString
        
        self.webView.load(urlRequest)
        
        return true
    }
    
    private func updateURL(from rawText: String?, reloadFromCache: Bool) -> URLRequest? {
        guard let urlTextValue = rawText,
              let urlComponents = URLComponents(string: urlTextValue),
              let unformattedURLValue = urlComponents.url else { return nil }
        
        let cachePolicy: URLRequest.CachePolicy = reloadFromCache ? .useProtocolCachePolicy : .reloadIgnoringCacheData
        
        var urlRequest: URLRequest?
        
        if let scheme = urlComponents.scheme,
           let _ = SupportedSchemes(rawValue: scheme),
           let urlValue = URL(string: unformattedURLValue.formatted(.url.locale(.current)))  {
            urlRequest = URLRequest(url: urlValue, cachePolicy: cachePolicy)
        } else if let unformattedURL = URL(string: SupportedSchemes.https.rawValue + SupportedSchemes.schemaFragment.rawValue +  unformattedURLValue.absoluteString),
                  let urlValue = URL(string: unformattedURL.formatted(.url.locale(.current))) {
            urlRequest = URLRequest(url: urlValue, cachePolicy: cachePolicy)
        }
        
        guard let urlRequestWithScheme = urlRequest else { return nil }
        
        return urlRequestWithScheme
    }
}
