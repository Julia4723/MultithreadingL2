//
//  ComplexRaceConditionViewController.swift
//  MultithreadingL2
//
//  Created by user on 22.05.2025.
//

import UIKit


class ThreadSafeArray<T> {
    private var array: [T] = []
    private let lock = NSLock()
    
    
    func append(_ value: T) {
        lock.lock()
        array.append(value)
        lock.unlock()
    }
    
    func snapshot() -> [T] {
        lock.lock()
        let copy = array
        lock.unlock()
        return copy
    }
}


final class ComplexRaceConditionViewController: UIViewController {
    private var counter = 0
    private let lock = NSLock()
    private var log: ThreadSafeArray<String> = ThreadSafeArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thread1 = Thread {
            for i in 0..<1000 {
                self.lock.lock()
                self.counter += 1
                self.lock.unlock()
                self.log.append("Thread 1 - step \(i)")
            }
            print("Thread 1 finished")
        }
        
        let thread2 = Thread {
            for i in 0..<1000 {
                self.lock.lock()
                self.counter += 1
                self.lock.unlock()
                self.log.append("Thread 2 - step \(i)")
            }
            print("Thread 2 finished")
        }
        
        thread1.start()
        thread2.start()
        
        Thread.sleep(forTimeInterval: 2)
        
        print("Final counter: \(counter) (ожидаем 2000)")
        print("Log count: \(log.snapshot().count) (ожидаем тоже 2000, но будет меньше или краш)")
    }
}

