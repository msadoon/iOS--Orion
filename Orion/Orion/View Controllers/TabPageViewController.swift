import UIKit
import WebKit

class TabPageViewController: UIPageViewController {
    var datasource =  TabPageViewControllerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialViewControllers()
    }
    
    // MARK: Setup
    private func setupInitialViewControllers() {
        guard let initialTabViewController = self.datasource.viewControllerAtIndex(.zero) else { return }
        
        self.setViewControllers([initialTabViewController], direction: .forward, animated: true)
    }
}

