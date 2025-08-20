//
//  TabVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabs()
        
    }
    
    
    private func loadTabs() {
        let todosVC = UINavigationController(rootViewController: TodosVC())
        todosVC.tabBarItem = UITabBarItem(
            title: "Todos",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        let featureVC = UINavigationController(rootViewController: UsersVC())
        featureVC.tabBarItem = UITabBarItem(
            title: "Feature",
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        
        let swiftui = UINavigationController(rootViewController: TodosViewVC())
        swiftui.tabBarItem = UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "square.and.arrow.up"),
            tag: 2
        )
        swiftui.tabBarItem.badgeValue = "New"
        viewControllers =  [todosVC, featureVC, swiftui]
    }
}

