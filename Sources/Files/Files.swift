import Foundation

public class Files {
    private static let manager = FileManager.default
    
    public static func read(_ file: String) -> Data? { try? Data(contentsOf: url(file)) }
    
    public static func write(_ file: String, _ data: Data?) -> Bool {
        guard let data = data else { return false }
        guard let _ = try? data.write(to: url(file)) else { return true }
        return false
    }
    
    public static func rewrite(_ file: String, _ data: Data?) -> Bool {
        guard let data = data else { return false }
        if exists(file) {
            if remove(file) {
                guard let _ = try? data.write(to: url(file)) else { return true }
            }
        } else {
            guard let _ = try? data.write(to: url(file)) else { return true }
        }
        return false
    }
    
    public static func files(_ folder: String = "") -> Array<String>? {
        try? manager.contentsOfDirectory(atPath: url(folder).path)
    }
    
    public static func folder(_ folder: String) -> Bool {
        guard !exists(folder) else { return false }
        guard let _ = try? manager.createDirectory(atPath: url(folder).path, withIntermediateDirectories: true) else { return true }
        return false
    }
    
    public static func remove(_ path: String) -> Bool {
        if path != "" {
            guard let _ = try? manager.removeItem(at: url(path)) else { return true }
        } else {
            guard let files = files() else { return false }
            for file in files {
                let path = directory.appendingPathComponent(file)
                guard let _ = try? manager.removeItem(at: path) else { continue }
            }
        }
        return true
    }
    
    public static func exists(_ file: String) -> Bool {
        manager.fileExists(atPath: url(file).path)
    }
    
    static func url(_ path: String) -> URL {
        directory.appendingPathComponent(path)
    }
    
    static var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension Files {//wip
    enum Object: Equatable {
        case all, file(String), folder(String)
        
        var paths: [String] {
            switch self {
            case .all: return []
            case .file(let file): return [file]
            case .folder(let file): return [file]
            }
        }
        static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.all, .all): return true
            case (.file(_), .file(_)): return true
            case (.folder(_), .folder(_)): return true
            default: return false
            }
        }
    }
}

extension String {
    private var manager: FileManager { FileManager.default }
    private var directory: URL { manager.urls(for: .documentDirectory, in: .userDomainMask).first! }
    var url: URL { directory.appendingPathComponent(self) }
    var path: String { url.path }
}
