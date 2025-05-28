//
//  DataRaceSaveSection.swift
//  MultithreadingL2
//
//  Created by user on 26.05.2025.
//

import UIKit

final class DataRaceSaveSection: UIViewController {
    
    private var counter = 0
    private let safeSection = SafeSection() //Объект блокировки
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let thread1 = Thread {
            for _ in 0..<1000 {
                self.safeSection.performLocked {
                    self.counter += 1 //критическая секция
                }
            }
            print("Thread 1 finished")
        }
        
        let thread2 = Thread {
            self.safeSection.performLocked {
                self.counter += 1 //критическая секция
            }
            print("Thread 2 finished")
        }
        
        thread1.start()
        thread2.start()
        
        Thread.sleep(forTimeInterval: 1) // Останавливает выполнение текущего потока на указанное количество секунд. В данном случае — на 1 секунду.
        print("Final counter value (ожидаем 2000, но может быть меньше): \(counter)")
    }
}
