//
//  SuccessPage.swift
//  GreenwealthPickup
//
//  Created by user1 on 21/02/24.
//

import SwiftUI

struct SuccessPage: View {
    
    @Binding var pageState: String
    
    var body: some View {
        VStack(spacing:40){
            Spacer()
            VStack(spacing:20){
                Image(systemName: "checkmark.circle")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(Color.primaryGreen)
                    .font(.system(size: 37,weight: .medium))
                Text("Pickup accepted successfully")
                    .font(.system(size: 17,weight: .medium))
            }
            .padding(30)
            .background(.white)
            .cornerRadius(10)
            Spacer()
            Button(action:{
                withAnimation{
                    pageState = "DashboardPage"
                }}){
                Text("Close")
                    .font(.system(size: 17,weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryGreen)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct previewSuccessPage: View {
    
    @State var pageState = "SuccessPage"
    
    var body: some View {
        SuccessPage(pageState: $pageState)
    }
}

#Preview {
    previewSuccessPage()
}
