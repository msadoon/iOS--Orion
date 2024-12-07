import Foundation
import UIKit

//FIXME: In notes mentiont that separating the data source and delegate is tricky because they are tied together tightly.
class TabPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var currentIndex = 0
    private var previousIndex = 0
    private var nextIndex = 0
    private var storyboard = UIStoryboard(name:StoryboardIds.main.referenceName, bundle: nil)
    
    // MARK: Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.viewControllerAtIndex(self.currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.viewControllerAtIndex(self.currentIndex + 1)
    }
    
    // MARK: Delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let lastViewController = (pendingViewControllers.last as? TabViewController),
              let page = lastViewController.page,
              let indexOfURLValue = TabPageDataProvider.shared.items.firstIndex(where: { $0.id == page.id }) else { return }
        
        self.nextIndex = indexOfURLValue
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else { return }
        
        guard let lastViewController = (previousViewControllers.last as? TabViewController),
                let page = lastViewController.page,
              let indexOfURLValue = TabPageDataProvider.shared.items.firstIndex(where: { $0.id == page.id }) else { return }
        
        
        self.previousIndex = indexOfURLValue
        
        guard self.previousIndex != self.nextIndex,
             self.currentIndex != self.nextIndex else { return }
        
        self.currentIndex = self.nextIndex
    }
    
    // MARK: Paging control
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        TabPageDataProvider.shared.items.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        self.currentIndex
    }
    
    // MARK: Helpers
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0, index < TabPageDataProvider.shared.items.count else { return nil }
        
        guard let tabViewController = self.storyboard.instantiateViewController(withIdentifier: String(describing: TabViewController.self)) as? TabViewController else {
            return nil
        }
        
        tabViewController.page = TabPageDataProvider.shared.items[index]
        
        return tabViewController
    }
}
