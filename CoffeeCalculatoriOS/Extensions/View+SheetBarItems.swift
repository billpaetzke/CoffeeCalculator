//
//  View+SheetBarItems.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

extension View {
    
    public func sheetBarItems<L, T>(leading: L, trailing: T) -> some View where L : View, T : View {
        VStack {
            
            HStack {
                
                leading
                
                Spacer()
                
                trailing
                
            }.padding()
            
            VStack {
                
                self
                
            }.frame(maxHeight: .infinity)
            
        }
    }
}


struct ViewSheetBarItems_Previews: PreviewProvider {
    
    static private var view: some View {
        VStack {
            Text("Some Data 1")
            Text("Some Data 2")
            Text("Some Data 3")
            Text("Some Data 4")
            Text("Some Data 5")
            Button(action: {}) {
                Text("A button")
            }
        }
        .sheetBarItems(leading:
            Button(action:{}) {
                Image(systemName: "xmark.circle")
            }
            , trailing: Button(action:{}) {
                Image(systemName: "plus.circle")
        })
    }
    
    
    
    static var previews: some View {
        
        Group {
            
            view
                .sheet(isPresented: .constant(true)) {
                    view
            }.previewDevice("iPhone SE (2nd generation)")
            
            view
                .sheet(isPresented: .constant(true)) {
                    view
            }.previewDevice("iPhone 8 Plus")
            
            view
                .sheet(isPresented: .constant(true)) {
                    view
            }.previewDevice("iPhone 11 Pro")
            
            view
                .sheet(isPresented: .constant(true)) {
                    view
            }.previewDevice("iPhone 11")
            
            view
                .sheet(isPresented: .constant(true)) {
                    view
            }.previewDevice("iPhone 11 Pro Max")
            
        }
        
    }
}
