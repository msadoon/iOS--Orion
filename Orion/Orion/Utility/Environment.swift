enum StoryboardIds: String {
    case main
    
    var referenceName: String {
        self.rawValue.capitalized
    }
}

enum SupportedSchemes: String {
    case schemaFragment = "://"
    case https
}
