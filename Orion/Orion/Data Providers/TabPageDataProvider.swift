import Foundation

final class TabPageDataProvider: DataProvider {
    typealias Item = TabPage
    static let shared = TabPageDataProvider()
    
    private(set) var items: [TabPage] = []
    
    func add(_ item: TabPage) {
        self.items.append(item)
    }
    
    func delete(_ item: TabPage) {
        self.items.removeAll { $0.id == item.id }
    }
    
    func update(_ item: TabPage) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
            
        self.items[index] = item
    }
    
    func fetchItem(id: UUID) -> TabPage? {
        self.items.first { $0.id == id }
    }
    
    func prepopulateItems() {
        let page1 = TabPage(title: "page 1", url: URL(string: "https://www.google.com")!, image: nil)
        let page2 = TabPage(title: "page 2", url: URL(string: "https://www.reddit.com")!, image: nil)
        let page3 = TabPage(title: "page 3", url: URL(string: "https://www.yahoo.com")!, image: nil)
        let page4 = TabPage(title: "page 4", url: URL(string: "https://www.apple.com")!, image: nil)
        let page5 = TabPage(title: "page 5", url: URL(string: "https://www.microsoft.com")!, image: nil)
        
        self.items = [page1, page2, page3, page4, page5]
    }
}
