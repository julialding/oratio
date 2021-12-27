import SwiftUI
import UIColorHexSwift

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        self = try Color(uiColor: UIColor(String(from: decoder)))
    }

    public func encode(to encoder: Encoder) throws {
        try UIColor(self).hexString().encode(to: encoder)
    }
}
