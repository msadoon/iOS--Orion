enum StoryboardIds: String {
    case main
    
    var referenceName: String {
        self.rawValue.capitalized
    }
}
