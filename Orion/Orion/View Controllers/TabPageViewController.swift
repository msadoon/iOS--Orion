import UIKit
import WebKit

class TabPageViewController: UIPageViewController {
    var datasource = TabPageViewControllerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPagingGestures()
        self.setupInitialViewControllers()
    }
    
    // MARK: Setup
    private func setupInitialViewControllers() {
        TabPageDataProvider.shared.prepopulateItems()
        guard let initialTabViewController = self.datasource.page(in: self, index: .zero) else { return }
        
        self.setViewControllers([initialTabViewController], direction: .forward, animated: true)
    }
    
    private func setupPagingGestures() { }
}

extension TabPageViewController: PageControlSwipe {
    func goToNextPage() {
        guard let pagingDatasource = self.dataSource as? TabPageViewControllerDataSource else { return }
        
        guard let page = pagingDatasource.nextPage(in: self) else { return }
        
        setViewControllers([page], direction: .forward, animated: true, completion: nil)
    }

    func goToPreviousPage() {
        guard let pagingDatasource = self.dataSource as? TabPageViewControllerDataSource else { return }
        
        guard let page = pagingDatasource.previousPage(in: self) else { return }
        
        setViewControllers([page], direction: .reverse, animated: true, completion: nil)
    }
}
