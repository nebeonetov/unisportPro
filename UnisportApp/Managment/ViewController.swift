//
//  ViewController.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

class ViewController: UIViewController {

    private let navigationBarBackgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
        private let navigationBarTitleColor = UIColor.white
        private let navigationBarTintColor = UIColor.white
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarAppearance()

        showGame()
                
                func showGame() {
                    // Створення SwiftUI View
                    let mainView = StartingView()
                    // Створення UIHostingController для вашого SwiftUI View
                    let hostingController = UIHostingController(rootView: mainView)
                    
                    // Додавання UIHostingController до вашого UIKit інтерфейсу
                    addChild(hostingController)
                    view.addSubview(hostingController.view)
                    hostingController.didMove(toParent: self)
                    
                    // Налаштування розміщення і розміру SwiftUI View
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                    ])
                }
    }

    private func configureNavigationBarAppearance() {
           // Создаем объект для настройки внешнего вида
           let appearance = UINavigationBarAppearance()

           // Настройка фона: делаем его НЕпрозрачным и задаем цвет
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = navigationBarBackgroundColor // Твой темный цвет фона

           // Настройка цвета и шрифта заголовка
           appearance.titleTextAttributes = [
               .foregroundColor: navigationBarTitleColor,
               // .font: UIFont.systemFont(ofSize: 17, weight: .semibold) // Можно настроить шрифт
           ]
           // Настройка цвета и шрифта большого заголовка (если используется .large)
           appearance.largeTitleTextAttributes = [
               .foregroundColor: navigationBarTitleColor,
               // .font: UIFont.systemFont(ofSize: 34, weight: .bold) // Можно настроить шрифт
           ]

           // Настройка цвета кнопок на баре (Back, Edit, etc.)
           let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
           barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: navigationBarTintColor]
           barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: navigationBarTintColor.withAlphaComponent(0.5)]
           barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: navigationBarTintColor.withAlphaComponent(0.8)]
           appearance.buttonAppearance = barButtonItemAppearance
           appearance.backButtonAppearance = barButtonItemAppearance // Важно для кнопки Back
           appearance.doneButtonAppearance = barButtonItemAppearance // Для кнопки Done

           // Применяем настроенный внешний вид ко всем состояниям NavigationBar
           UINavigationBar.appearance().standardAppearance = appearance // Когда контент скроллится под бар
           UINavigationBar.appearance().scrollEdgeAppearance = appearance // Когда контент не доходит до бара (обычно для .large заголовков)
           UINavigationBar.appearance().compactAppearance = appearance // Для компактного вида (напр., при split view)

           // Опционально: Настройка цвета стрелки "Назад" и других элементов
           UINavigationBar.appearance().tintColor = navigationBarTintColor // Цвет стрелки и значков кнопок
       }
}

