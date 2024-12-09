import Foundation
import UIKit

class TabPageViewControllerDataSource: NSObject {
    private var storyboard = UIStoryboard(name:StoryboardIds.main.referenceName, bundle: nil)
    private var index = 0
    // FIXME: Clean up duplicate code, use SwipeDirection enum.
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
