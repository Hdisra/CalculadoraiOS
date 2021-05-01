//
//  AppDelegate.swift
//  iOS-Calculator
//
//  Created by Israel Hernandez on 08/07/20.
//  Copyright © 2020 Israel Hernandez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    //se ejecute cuando arrancamos la app
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Llamamos a la función Setup
        setupView()
        
        return true
    }
    
    // MARK: FUNCIONES PRIVADAS
    
    private func setupView() {
        
        //primero instanciamos window 
        window = UIWindow(frame: UIScreen.main.bounds) //frame es el tamaño que queremos que tenga la window, en este caso la totalidad de la pantalla del dispositivo(UIScreen.main.bounds)
        
        //le diremos cual sera la primera vista que se mostrará, instanciandola
        let vc = HomeViewController()
        //le decimos a la ventana que el controlador de vista principal sera el vc osea el HomeViewController
        window?.rootViewController = vc
        //y le decimos que se muestre
        window?.makeKeyAndVisible()
        
    }
    

    

}

