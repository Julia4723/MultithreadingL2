//
//  PriorityInversionViewController.swift
//  MultithreadingL2
//
//  Created by brubru on 19.05.2025.
//

import UIKit

final class PriorityInversionViewController: UIViewController {
	
	private let lock = NSLock()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		startLowPriorityThread()
		
		// Делаем паузу, чтобы low успел захватить lock
		Thread.sleep(forTimeInterval: 0.1)
		
		startHighPriorityThread()
		
		// Medium запускается позже, но съедает всё CPU
		Thread.sleep(forTimeInterval: 0.1)
		startMediumPriorityThread()
	}
	
	private func startLowPriorityThread() {
		let low = Thread {
			self.lock.lock()
			print("LOW: Захватил lock, начинаю долгую работу")
			Thread.sleep(forTimeInterval: 3) // долго держит lock
			print("LOW: Освобождаю lock")
			self.lock.unlock()
		}
		low.name = "Low"
		low.qualityOfService = .background //низкий приоритет
		low.start()
	}
	
	private func startHighPriorityThread() {
		let high = Thread {
			print("HIGH: Хочу захватить lock")
			self.lock.lock()
			print("HIGH: Получил lock, работаю")
			self.lock.unlock()
		}
		high.name = "High"
        high.qualityOfService = .userInitiated // высокий приоритет
		high.start()
	}
	
	private func startMediumPriorityThread() {
		let medium = Thread {
			print("MEDIUM: Просто много работаю без lock")
			for i in 1...10 {
				print("MEDIUM: Работаю \(i)")
				Thread.sleep(forTimeInterval: 0.3) // активно съедает CPU
			}
		}
		medium.name = "Medium"
		medium.qualityOfService = .utility //средний приоритет
		medium.start()
	}
}
