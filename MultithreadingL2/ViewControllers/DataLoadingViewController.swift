//
//  DataLoadingViewController.swift
//  MultithreadingL2
//
//  Created by user on 26.05.2025.
//

import UIKit

final class DataLoadingViewController: UIViewController {
    private var dataReady = false
    private var loadedText: String?
    private var label: UILabel!
    
    let condition = NSCondition()
    var ready = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label = UILabel(frame: CGRect(x: 40, y: 200, width: 300, height: 30))
        label.text = "Ждём данные..."
        view.addSubview(label)
        
        
        // Поток 1: Пытается читать данные
        Thread {
            self.condition.lock()
            print("Ждём данные...")
            while !self.dataReady {
                self.condition.wait()
            }
            self.performSelector(onMainThread: #selector(self.updateUI), with: nil, waitUntilDone: false)
            self.condition.unlock()
        }.start()
        
        
        // Поток 2: Загружает данные с задержкой
        Thread {
            sleep(2) // Имитация долгой загрузки данных.
            self.condition.lock()
            self.loadedText = "Данные загружены!"
            self.dataReady = true
            self.condition.signal()
            self.condition.unlock()
            print("Данные готовы")
        }.start()
    }
    
    @objc private func updateUI() {
        label.text = loadedText
        print("✅ Обновили UI: \(loadedText ?? "")")
    }
}
