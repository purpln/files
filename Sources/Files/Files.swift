import Foundation

class Files {
    private static let manager = FileManager.default
    private static let url = URL.directory
    
    static func read(_ file: String, completion: @escaping (Data?)->Void) {
        let path = url.appendingPathComponent(file)
        completion(try? Data(contentsOf: path))
    }
    
    static func write(_ file: String, _ data: Data?, completion: @escaping (Bool)->Void) {
        let path = url.appendingPathComponent(file)
        guard let data = data else {
            completion(false)
            return
        }
        guard let _ = try? data.write(to: path) else {
            completion(false)
            return
        }
        completion(true)
    }
    
    static func folder(_ folder: String, completion: @escaping (Bool)->Void) {
        let path = url.appendingPathComponent(folder)
        if !manager.fileExists(atPath: path.path) {
            guard let _ = try? manager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil) else {
                completion(false)
                return
            }
            completion(true)
        } else { completion(false) }
    }
    
    static func files(_ folder: String = "", completion: @escaping (Array<String>?)->Void) {
        let path = url.appendingPathComponent(folder)
        
        guard let values = try? manager.contentsOfDirectory(atPath: path.path) else {
            completion(nil)
            return
        }
        completion(values)
    }
    
    static func remove(_ path: String = "", completion: @escaping (Bool)->Void) {
        if path != "" {
            let path = url.appendingPathComponent(path)
            do {
                try manager.removeItem(at: path)
                completion(true)
            } catch { completion(false) }
        } else {
            files() { [self] result in
                guard let files = result else {
                    completion(false)
                    return
                }
                for file in files {
                    let path = url.appendingPathComponent(file)
                    do {
                        try manager.removeItem(at: path)
                    } catch { completion(false) }
                }
                completion(true)
            }
        }
    }
}

private extension URL {
    static var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
