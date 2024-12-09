import UIKit
import WebKit

class TabPageViewController: UIPageViewController {
    private var datasource = TabPageViewControllerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialViewControllers()
    }
    
    // MARK: Setup
    private func setupInitialViewControllers() {
        TabPageDataProvider.shared.prepopulateItems()
        guard let initialTabViewController = self.datasource.page(in: self, index: .zero) else { return }
        
        self.setViewControllers([initialTabViewController], direction: .forward, animated: true)
    }
}

extension TabPageViewController: PageControlSwipe {
    func go(direction: UIPageViewController.NavigationDirection) {
        var page: UIViewController
        
        switch direction {
        case .forward:
            guard let navigablePage = self.datasource.nextPage(in: self) else { return }
            
            page = navigablePage
        case .reverse:
            guard let navigablePage = self.datasource.previousPage(in: self) else { return }
            
            page = navigablePage
        @unknown default:
            return
        }
        
        setViewControllers([page], direction: direction, animated: true, completion: nil)
    }
}
