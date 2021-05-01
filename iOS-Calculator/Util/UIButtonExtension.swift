//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Israel Hernandez on 09/07/20.
//  Copyright © 2020 Israel Hernandez. All rights reserved.
//

import UIKit

private let naranja = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 3)

//para poder hacer aqui cambios en las propiedades de los botones
extension UIButton {
    
    //para hacer el borde redondo
    func round() {
        
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    //para que brille al pulsar un botón
    func brillar() {
        
        //agarra la vista del boton y la anima rapidamente para que desaparezca y aparezca rapidamente
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
            
        }
    }
    
    //para cambiar su representacion grafica cuando este seleccionado un boton con un parametor para saber si el boton esta seleccionado o no. y ponemos un guion enfrente para que al llamr a selectOperation no aparezca esa palabra
    func selectOperation(_ selected: Bool) {
        
        //cambiaremos su color y si selected es true entonces va a ser blanco y si no esta seleccionado va a ser naranja
        backgroundColor = selected ? .white : naranja
        //para el texto
        setTitleColor(selected ? naranja : .white, for: .normal)
    }

}
