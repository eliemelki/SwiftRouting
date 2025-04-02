//
//  hasPrice.swift
//  SwiftRouting
//
//  Created by Elie Melki on 01/04/2025.
//


public protocol DYProduct {
    var value: Double { get }
}

open class BaseProduct: DYProduct {
    open var value: Double {
        return 1.0
    }
}

public class Product: BaseProduct {
   
    public override init() {
        
    }
    
}


public class X {
    public static func display(p: Product, ps:[Product] ) {
        print(p.value)
        ps.forEach { print($0.value) }
    }
}
