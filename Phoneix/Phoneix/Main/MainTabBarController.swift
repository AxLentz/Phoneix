//
//  MainTabBarController.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/7.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barStyle = .black

        addChildVC()
    }


    private func addChildVC() {
//        guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
//        let data = NSData(contentsOfFile: path),
//        let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: AnyObject]]
//            else {
//            return
//        }
//
//        var arrayM = [UIViewController]()
//        for dict in array! {
//            arrayM.append(contoller(dict: dict))
//        }
//
//        viewControllers = arrayM
        
        let dictArr = [["clsName": "HomeViewController", "title": "Home", "imgName": "home"],
                       ["clsName": "CategoriesViewController", "title": "Categories", "imgName": "categories"],
                       ["clsName": "PostViewController", "title": "Post", "imgName": "post"],
                       ["clsName": "CommunityViewController", "title": "Community", "imgName": "community"],
                       ["clsName": "MeViewController", "title": "Me", "imgName": "me"]]
        
        var vcArr = [UIViewController]()
        for dict in dictArr {
            vcArr.append(contoller(dict: dict as [String : AnyObject]))
        }
        viewControllers = vcArr
    }
    
    
    private func contoller(dict: [String: AnyObject]) -> UIViewController {
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imgName = dict["imgName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
            else {
                return UIViewController()
        }
        
        let vc = cls.init()
        
        vc.title = title
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imgName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imgName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Color.blue], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: UIControlState.normal)
        
        let nav = MainNavigationController(rootViewController: vc)
        
        return nav
    }

}














































