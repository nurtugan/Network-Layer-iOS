// source: https://github.com/roberthein/Observable
// version: 2.0.1

import Foundation

// MARK: - Observable
class Observable<T> {
    
    typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock = NSRecursiveLock()
    
    fileprivate var _value: T {
        didSet {
            let newValue = _value
            observers.values.forEach { observer, dispatchQueue in
                notify(observer: observer, queue: dispatchQueue, value: newValue, oldValue: oldValue)
            }
        }
    }
    
    var wrappedValue: T {
        return _value
    }
      
    fileprivate var _onDispose: () -> Void
    
    init(_ value: T, onDispose: @escaping () -> Void = {}) {
        _value = value
        _onDispose = onDispose
    }
    
    init(wrappedValue: T) {
        _value = wrappedValue
        _onDispose = {}
    }
    
    func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        notify(observer: observer, queue: queue, value: wrappedValue)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
            self?._onDispose()
        }
        
        return disposable
    }
    
    func removeAllObservers() {
        observers.removeAll()
    }
    
    func asObservable() -> Observable<T> {
        return self
    }
    
    fileprivate func notify(observer: @escaping Observer, queue: DispatchQueue? = nil, value: T, oldValue: T? = nil) {
        if let queue = queue {
            queue.async {
                observer(value, oldValue)
            }
        } else {
            observer(value, oldValue)
        }
    }
}

// MARK: - MutableObservable
@propertyWrapper
final class MutableObservable<T>: Observable<T> {
    override var wrappedValue: T {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}
