//
//  SuccessPage.swift
//  GreenwealthPickup
//
//  Created by user1 on 21/02/24.
//

import SwiftUI

struct CompletionPage: View {
    
    @Binding var pageState: String
    
    var body: some View {
        VStack(spacing:40){
            Spacer()
            VStack(spacing:20){
                Image(systemName: "checkmark.circle")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(Color.primaryGreen)
                    .font(.system(size: 37,weight: .medium))
                Text("Pickup completed successfully")
                    .font(.system(size: 17,weight: .medium))
            }
            .padding(30)
            .background(.white)
            .cornerRadius(10)
            Spacer()
            Button(action:{
                withAnimation{
                    pageState = "QueuePage"
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

struct previewCompletionPage: View {
    
    @State var pageState = "SuccessPage"
    
    var body: some View {
        CompletionPage(pageState: $pageState)
    }
}

#Preview {
    previewCompletionPage()
}
