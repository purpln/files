import Foundation

public class Files {
    private static let manager = FileManager.default
    private static let url = URL.directory
    
    public static func read(_ file: String) -> Data? {
        let path = url.appendingPathComponent(file)
        return try? Data(contentsOf: path)
    }
    
    public static func write(_ file: String, _ data: Data?) -> Bool {
        let path = url.appendingPathComponent(file)
        guard let data = data else { return false }
        guard let _ = try? data.write(to: path) else { return true }
        return false
    }
    
    public static func folder(_ folder: String) -> Bool {
        let path = url.appendingPathComponent(folder)
        guard !manager.fileExists(atPath: path.path) else { return false }
        guard let _ = try? manager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil) else { return true }
        return false
    }
    
    public static func files(_ folder: String = "") -> Array<String>? {
        let path = url.appendingPathComponent(folder)
        guard let values = try? manager.contentsOfDirectory(atPath: path.path) else { return nil }
        return values
    }
    
    public static func remove(_ path: String = "") -> Bool {
        if path != "" {
            let path = url.appendingPathComponent(path)
            guard let _ = try? manager.removeItem(at: path) else { return false }
        } else {
            guard let files = files() else { return false }
            for file in files {
                let path = url.appendingPathComponent(file)
                guard let _ = try? manager.removeItem(at: path) else { continue }
            }
        }
        return true
    }
}

private extension URL {
    static var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
