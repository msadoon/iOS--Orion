protocol DataProvider: AnyObject {
    associatedtype Item: Identifiable
    var items: [Item] { get }
    
    func add(_ item: Item)
    func delete(_ item: Item)
    func update(_ item: Item)
    func fetchItem(id: Item.ID) -> Item?
}
