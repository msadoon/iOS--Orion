import Foundation
import UIKit

//FIXME: In notes mentiont that separating the data source and delegate is tricky because they are tied together tightly.
class TabPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var storyboard = UIStoryboard(name:StoryboardIds.main.referenceName, bundle: nil)
    private var index = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? { nil }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? { nil }
    /**
    private var previousIndex = 0
    private var nextIndex = 0
    
    // MARK: Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let swipablePageViewController = pageViewController as? PageControlSwipe else { return nil }
        
        return self.viewControllerAtIndex(in: swipablePageViewController, self.currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let swipablePageViewController = pageViewController as? PageControlSwipe else { return nil }
        
        return self.viewControllerAtIndex(in: swipablePageViewController, self.currentIndex + 1)
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
     */
    // MARK: Helpers
    func page(in pageController: PageControlSwipe, index: Int) -> UIViewController? {
        guard index >= 0, index < TabPageDataProvider.shared.items.count else { return nil }
        
        guard let tabViewController = self.storyboard.instantiateViewController(withIdentifier: String(describing: TabViewController.self)) as? TabViewController else {
            return nil
        }
        
        tabViewController.page = TabPageDataProvider.shared.items[index]
        tabViewController.delegate = pageController
        
        return tabViewController
    }
    
    func nextPage(in pageController: PageControlSwipe) -> UIViewController? {
        self.incrementIndex()
        
        guard self.index >= 0, self.index < TabPageDataProvider.shared.items.count else {
            self.decrementIndex()
            
            return nil
        }
        
        guard let tabViewController = self.storyboard.instantiateViewController(withIdentifier: String(describing: TabViewController.self)) as? TabViewController else {
            return nil
        }
        
        tabViewController.page = TabPageDataProvider.shared.items[self.index]
        tabViewController.delegate = pageController
        
        return tabViewController
    }
    
    func previousPage(in pageController: PageControlSwipe) -> UIViewController? {
        self.decrementIndex()
        
        guard self.index >= 0, self.index < TabPageDataProvider.shared.items.count else {
            self.incrementIndex()
            
            return nil
        }
        
        guard let tabViewController = self.storyboard.instantiateViewController(withIdentifier: String(describing: TabViewController.self)) as? TabViewController else {
            return nil
        }
        
        tabViewController.page = TabPageDataProvider.shared.items[self.index]
        tabViewController.delegate = pageController
        
        return tabViewController
    }
    
    func decrementIndex() {
        self.index -= 1
    }
    
    func incrementIndex() {
        self.index += 1
    }
}
