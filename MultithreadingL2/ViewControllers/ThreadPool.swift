//
//  ThreadPool.swift
//  MultithreadingL2
//
//  Created by user on 30.05.2025.
//

import UIKit

final class ThreadPool {
    private var threads: [Thread] = [] //массив с потоками
    private var taskQueue: [() -> Void] = [] // массив с задачами
    private let condition = NSCondition()
    private var isStopped = false
    
    init(numberOgThreads: Int) {
        for i in 0..<numberOgThreads {
            let thread = Thread {
                self.threadLoop(index: i)//запускаем бесконечный цикл
            }
            thread.start()
            threads.append(thread)
        }
    }
    
    private func threadLoop(index: Int) {
        while true {
            //1.Ждем задачу
            condition.lock()
            while taskQueue.isEmpty {
                condition.wait()
            }
            
            //остановка потока
            if isStopped {
                condition.unlock()
                break
            }
            
            //2. Получаем задачу из очереди
            let task = taskQueue.removeFirst()
            condition.unlock()
            
            //3.Выполняем задачу
            print("поток \(index) исполнят задачу")
            task()
        }
    }
    
    //метод по добавлению задачи в очередь.
    private func addTask(task: @escaping () -> Void) {
        taskQueue.append(task)
    }
    
    //метод для остановки всех потоков
    private func stopThreads() {
        isStopped = true
        condition.broadcast()
    }
}
