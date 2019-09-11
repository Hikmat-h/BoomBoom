//
//  ActionResultDelegate.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import UIKit

//  уведомление другого контроллера о своем дейстии и передача объекта (если необходимо)
protocol ActionResultDelegate{
    
    func done(source:UIViewController, data:Any?) // ОК, сохранить
    
    func cancel(source:UIViewController, data:Any?) // отмена действия
    
}

// реализации по-умолчанию для интерфейса
extension ActionResultDelegate{
    
    func done(source: UIViewController, data: Any?) {
        fatalError("not implemented")
    }
    
    func cancel(source: UIViewController, data: Any?) {
        fatalError("not implemented")
    }
    
}
