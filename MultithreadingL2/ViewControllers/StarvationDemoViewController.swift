//
//  StarvationDemoViewController.swift
//  MultithreadingL2
//
//  Created by brubru on 19.05.2025.
//

import UIKit

final class StarvationDemoViewController: UIViewController {

	private let lock = NSLock()
	private var sharedCounter = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		// Жадный поток — с высоким приоритетом
		let greedyThread = Thread {
			while self.sharedCounter < 1000 {
				self.lock.lock()
				self.sharedCounter += 1
				print("Greedy thread: \(self.sharedCounter)")
				self.lock.unlock()
				// Без паузы — он «топчет» замок постоянно
			}
		}
		greedyThread.qualityOfService = .userInteractive // Высокий приотитет задачи.

		// Голодный поток — с низким приоритетом
		let starvingThread = Thread {
			while self.sharedCounter < 1000 {
				self.lock.lock()
				self.sharedCounter += 10
				print("🥶 Starving thread: \(self.sharedCounter)")
				self.lock.unlock()
			}
		}
		starvingThread.qualityOfService = .background // Низкий приотитет задачи.

		greedyThread.start()
		starvingThread.start()
	}
}
