//
//  VerificationPage.swift
//  GreenwealthPickup
//
//  Created by user1 on 21/02/24.
//

import SwiftUI

struct VerificationPage: View {
    
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var pickupId: Int
    
    @State var isPageLoading: Bool = false
    @State var isToastPresented: Bool = false
    @State var toastMessage: String = ""
    
    @State var customerOTP: String = ""
    @State var finalPrice: String = ""
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserLattitude: String = UserDefaults.standard.string(forKey: "LoggedUserLattitude") ?? ""
    @State private var loggedUserLongitude: String = UserDefaults.standard.string(forKey: "LoggedUserLongitude") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func verifyOTP() async{
        if(customerOTP == pickupModel.currentPickup[0].otp){
            isPageLoading = true
            let userID = pickupModel.currentPickup[0].userId
            try? await pickupModel.getuser(userId: userID)
            try? await pickupModel.completeOrder(pickupId: pickupId, finalPrice: finalPrice, userId: userID)
            try? await pickupModel.getAcceptedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getStartedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCollectedPickups(collectorID: Int(loggedUserID)!)
            try? await pickupModel.getCompletedPickups(collectorID: Int(loggedUserID)!)
            if(pickupModel.responseStatus == 200){
                isPageLoading = false
                pageState = "CompletionPage"
            }
            else{
                isToastPresented = true
                toastMessage = "Something went wrong"
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                    withAnimation{
                        isToastPresented.toggle()
                    }
            }
        }
        else{
            isToastPresented = true
            toastMessage = "OTP mismatch"
            try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation{
                    isToastPresented.toggle()
                }
        }
    }
    
    var body: some View {
        VStack{
            if(isPageLoading){
                LoadingPage()
            }
            else{
                ZStack{
                    if(isToastPresented){
                        VStack{
                            Text("\(toastMessage)")
                                .font(.system(size: 14,weight: .regular))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,20)
                        .background(.red.opacity(0.8))
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.red.opacity(0.8),lineWidth:4)
                        )
                        .padding(.horizontal,20)
                        .zIndex(1)
                        .offset(y:-360)
                    }
                    VStack{
                        HStack{
                            Button(action:{
                                withAnimation{
                                    pageState = "DashboardPage"
                                }
                            }){
                                Image(systemName: "chevron.left")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(Color.primaryGreen)
                                    .font(.system(size: 17,weight: .semibold))
                            }
                            Spacer()
                            Text("Verify customer OTP")
                                .font(.system(size: 17,weight: .bold))
                                .padding(.vertical,10)
                            Spacer()
                        }
                        .padding(.horizontal,40)
                        Spacer()
                        VStack{
                            TextField("Final Price", text: $finalPrice)
                                .font(.system(size: 17, weight: .bold))
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                            TextField("Customer OTP", text: $customerOTP)
                                .font(.system(size: 17, weight: .bold))
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action:{
                            Task{
                                await verifyOTP()
                            }
                        }){
                            Text("Verify")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 17, weight: .medium))
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.primaryGreen)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .background(Color.primaryBackground)
            }
        }
    }
}

struct previewVerificationPage: View {
    
    @StateObject var pickupModel = pickupsModel()
    @State var pageState: String = "VerificationPage"
    @State var pickupId: Int = 0
    
    var body: some View {
        VerificationPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
    }
}

#Preview {
    previewVerificationPage()
}
