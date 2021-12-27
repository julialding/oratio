import Foundation

extension UserDefaults {
    func encode<T: Encodable>(_ value: T, forKey key: String) {
        let data = try! JSONEncoder().encode(value)
        self.set(data, forKey: key)
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }
}
