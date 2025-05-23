//
//  ViewController.swift
//  MultithreadingL2
//
//  Created by brubru on 19.05.2025.
//

import UIKit

final class DataRaceViewController: UIViewController {
    
    private var counter = 0
    private let lock = NSLock() //Объект блокировки
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Основной поток — тоже увеличивает счётчик
        for _ in 0..<1000 {
            lock.lock()
            counter += 1
            lock.unlock()
        }
        
        let thread1 = Thread {
            for _ in 0..<1000 {
                self.lock.lock() //поток “входит” в секцию и блокирует доступ другим.
                self.counter += 1 //self - это объект класса UIViewController
                self.lock.unlock() // освобождает путь для других.
            }
            print("Thread 1 finished")
        }
        
        let thread2 = Thread {
            for _ in 0..<1000 {
                self.lock.lock()
                self.counter += 1
                self.lock.unlock()
            }
            print("Thread 2 finished")
        }
        
        thread1.start()
        thread2.start()
        
        Thread.sleep(forTimeInterval: 1) // Останавливает выполнение текущего потока на указанное количество секунд. В данном случае — на 1 секунду.
        print("Final counter value (ожидаем 2000, но может быть меньше): \(counter)")
    }
}


