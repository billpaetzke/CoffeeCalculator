//
//  SheetViewExtension.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 4/13/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
/*
extension View {
    // Workaround
    public func sheet<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        
        ZStack {
            self
                .offset(y: isPresented.wrappedValue ? -WKInterfaceDevice.current().screenBounds.height : 0)

            VStack {
                Image(systemName: "xmark.circle.fill")
                    .padding([.top,.horizontal])
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
                
                content()
            }
            .offset(y: isPresented.wrappedValue ? 0 : WKInterfaceDevice.current().screenBounds.height)
            
        }.animation(.spring(response: 0.2, dampingFraction: 0.8, blendDuration: 0))
        
        /*VStack {
         
         HStack {
         Image(systemName: "xmark.circle.fill").imageScale(.large)
         .onTapGesture {
         isPresented.wrappedValue = false
         }
         Spacer()
         }.padding(.top)
         
         //ScrollView {
         content()
         //}
         }*/
        
        
    }
}

struct SheetViewExtension_Previews: PreviewProvider {
    
    @State static private var isSheetShown = true
    
    static var previews: some View {
        VStack {
            TextField("Field 1", text: .constant(String()))
            Text("Field 2")
            Text("Field 3")
            Button(action: { isSheetShown = true }) {
                Text("Show Sheet")
            }
        }.sheet(isPresented: $isSheetShown) {
            Form {
                TextField("Field 1", text: .constant(String()))
                TextField("Field 2", text: .constant(String()))
                TextField("Field 3", text: .constant(String()))
                Button(action: { isSheetShown = false}) {
                    Text("Do Something")
                }
            }
        }
    }
}
*/
