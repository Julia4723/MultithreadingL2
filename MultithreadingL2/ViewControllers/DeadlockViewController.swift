//
//  DeadlockViewController.swift
//  MultithreadingL2
//
//  Created by brubru on 19.05.2025.
//

import UIKit

final class DeadlockViewController: UIViewController {

	private let lock1 = NSLock()
	private let lock2 = NSLock()

	override func viewDidLoad() {
		super.viewDidLoad()

		let thread1 = Thread {
			print("Thread 1: trying to lock lock1")
			self.lock1.lock()
			print("Thread 1: locked lock1")

			// Имитация задержки, чтобы второй поток успел захватить lock2
			Thread.sleep(forTimeInterval: 0.1)

			print("Thread 1: trying to lock lock2")
			self.lock2.lock()
			print("Thread 1: locked lock2")

			print("Thread 1: doing work...")
			self.lock2.unlock()
			self.lock1.unlock()
			print("Thread 1 finished")
		}

		let thread2 = Thread {
			print("Thread 2: trying to lock lock2")
			self.lock2.lock()
			print("Thread 2: locked lock2")

			// Имитация задержки, чтобы первый поток успел захватить lock1
			Thread.sleep(forTimeInterval: 0.1)

			print("Thread 2: trying to lock lock1")
			self.lock1.lock()
			print("Thread 2: locked lock1")

			print("Thread 2: doing work...")
			self.lock1.unlock()
			self.lock2.unlock()
			print("Thread 2 finished")
		}

		thread1.start()
		thread2.start()
	}
}
