//
//  TabBarController.swift
//  FloatingAudioPlayer_Example
//
//  Created by Zhangali Pernebayev on 11/15/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        tabBar.tintColor = UIColor.white
        
        let vc1 = AudioTableViewController(mode: .music)
        vc1.tabBarItem.title = "Music"
        vc1.tabBarItem.image = #imageLiteral(resourceName: "music")
        let nav1 = UINavigationController(rootViewController: vc1)
        
        let vc2 = AudioTableViewController(mode: .podcast)
        vc2.tabBarItem.title = "Podcast"
        vc2.tabBarItem.image = #imageLiteral(resourceName: "podcast")
        let nav2 = UINavigationController(rootViewController: vc2)
        
        viewControllers = [nav1, nav2]
    }
}
