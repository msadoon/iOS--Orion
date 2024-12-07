import Foundation
import UIKit

//FIXME: In notes mentiont that separating the data source and delegate is tricky because they are tied together tightly.
class TabPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var currentIndex = 0
    private var previousIndex = 0
    private var nextIndex = 0
    private var allWebsites = ["https://www.google.com", "https://www.yahoo.com", "https://www.reddit.com"]
    private var storyboard = UIStoryboard(name:StoryboardIds.main.referenceName, bundle: nil)
    
    // MARK: Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard self.currentIndex - 1 >= 0 else {
            return nil
        }
        print("*** after should check index at \(self.currentIndex - 1)")
        return self.viewControllerAtIndex(self.currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard self.currentIndex + 1 < self.allWebsites.count else {
            return nil
        }
        
        print("*** after should check index at \(self.currentIndex + 1)")
        return self.viewControllerAtIndex(self.currentIndex + 1)
    }
    
    // MARK: Delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("*** will transition to: \(pendingViewControllers.map { ($0 as! TabViewController).rawURLValue })")
        //FIXME: Do all this with a separate data provider
        guard let lastViewController = (pendingViewControllers.last as? TabViewController),
                let urlValue = lastViewController.rawURLValue,
              let indexOfURLValue = self.allWebsites.firstIndex(where: { $0 == urlValue }) else { return }
        
        self.nextIndex = indexOfURLValue
        print("*** next \(self.nextIndex)")
        print("*** current \(self.currentIndex)")
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else { return }
        //FIXME: Checking website URLs is not accurate - use UUIDs.
        guard let lastViewController = (previousViewControllers.last as? TabViewController),
                let urlValue = lastViewController.rawURLValue,
              let indexOfURLValue = self.allWebsites.firstIndex(where: { $0 == urlValue }) else { return }
        
        
        self.previousIndex = indexOfURLValue
        print("*** previous \(self.previousIndex)")
        print("*** current \(self.currentIndex)")
        
        switch ((self.previousIndex < self.nextIndex), (self.previousIndex > self.nextIndex)) {
        case (true, false):
            self.currentIndex = self.nextIndex
        case (false, true):
            self.currentIndex = self.previousIndex
        default:
            break
        }
    }
    
    // MARK: Paging control
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.allWebsites.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        self.currentIndex
    }
    
    // MARK: Helpers
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard let tabViewController = self.storyboard.instantiateViewController(withIdentifier: String(describing: TabViewController.self)) as? TabViewController else {
            return nil
        }
        
        tabViewController.rawURLValue = self.allWebsites[index]
        
        print("*** view at index \(index)")
        
        return tabViewController
    }
}
