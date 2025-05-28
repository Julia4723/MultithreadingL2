//
//  SafeSection.swift
//  MultithreadingL2
//
//  Created by user on 26.05.2025.
//

import UIKit

class SafeSection {
    private let lockMutex = NSLock()
    
    func performLocked(_ block: () -> Void) {
        lockMutex.lock()
        print("Locking performed...")
        defer {
            lockMutex.unlock()
        }
        callMy() // Вызов метода, внутри критической секции.
        block()
        print("Exit performLocked")
    }
    
    private func callMy() {
        lockMutex.lock()
        print("Locking called...")
        defer {
            lockMutex.unlock()
        }
        print("Exit callMy")
    }
}


//Использование Recursive Lock. Данный примитив позволяет одному и тому же потоку захватывать мьютекс несколько раз подряд, не вызывая взаимной блокировки.
/*
class SafeSection {
    private let lockMutex = NSRecursiveLock() // Просто меняем примитив.
    
    func performLocked(_ block: () -> Void) {
        lockMutex.lock()
        print("Locking performed...")
        defer {
            lockMutex.unlock()
        }
        callMy() // Вызов метода, внутри критической секции.
        block()
        print("Exit performLocked")
    }
    
    private func callMy() {
        lockMutex.lock()
        print("Locking called...")
        defer {
            lockMutex.unlock()
        }
        print("Exit callMy")
    }
}
*/
