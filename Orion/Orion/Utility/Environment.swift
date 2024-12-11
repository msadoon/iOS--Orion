import UIKit

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

enum Images: String {
    case refresh = "arrow.clockwise.circle.fill"
}

enum Padding: CGFloat {
    case standard = 20
    case thin = 10
}
