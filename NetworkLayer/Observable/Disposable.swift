import Foundation

typealias Disposal = [Disposable]

extension Disposal {
    func dispose() {
        forEach { disposable in
            disposable.dispose()
        }
    }
}

final class Disposable {
    
    let dispose: () -> ()
    
    init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
    
    func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
