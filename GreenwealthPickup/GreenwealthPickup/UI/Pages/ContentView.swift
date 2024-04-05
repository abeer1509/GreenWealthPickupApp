//
//  ContentView.swift
//  GreenwealthPickup
//
//  Created by user1 on 20/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var pickupData = pickUp()
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
//    @StateObject private var requestModel = requestsModel()
    
    @State var pickupId: Int = 0
    
    @State private var isBoarded: Bool = UserDefaults.standard.bool(forKey: "BoardingState")
    
    @State var pageState = "LaunchPage"
    @State var previousPageState = "LaunchPage"
    @State var isOrdered = false
    @State var presentOnBoarding: Bool = false
    
    var body: some View {
        VStack {
            if(pageState == "LaunchPage"){
                LaunchPage(userModel: userModel, pickupModel: pickupModel, pickUp: pickupData, pageState: $pageState)
            }
            else if(pageState == "SigninPage"){
                SigninPage(userModel: userModel, pickupModel: pickupModel, pageState: $pageState, previousPageState: $previousPageState)
            }
            else if(pageState == "SignupPage"){
                SignupPage(userModel: userModel, pickupModel: pickupModel, pageState: $pageState, previousPageState: $previousPageState)
            }
            else if(pageState == "SuccessPage"){
                SuccessPage(pageState: $pageState)
            }
            else if(pageState == "CompletionPage"){
                CompletionPage(pageState: $pageState)
            }
            else{
                ZStack{
                    VStack{
                        Navbar(pageState: $pageState, previousPageState: $previousPageState)
                        Spacer()
                        if(pageState == "DashboardPage"){
                            DashboardPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
                        }
                        else if(pageState == "ProfilePage"){
                            ProfilePage(pageState: $pageState, previousPageState: $previousPageState, userModel: userModel, pickupModel: pickupModel)
                        }
                        else if(pageState == "PickupPage"){
                            PickupPage(pickupModel: pickupModel, pickupId: $pickupId, pageState: $pageState)
                        }
                        else if(pageState == "QueuePage"){
                            PickupQueuePage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
                        }
                        else if(pageState == "ActionPage"){
                            ActionPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
                        }
                        else if(pageState == "VerificationPage"){
                            VerificationPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
                        }
                        Spacer()
                        Tabbar(pageState: $pageState, previousPageState: $previousPageState)
                    }
                }
                .background(Color.primaryBackground)
            }
        }
    }
}

#Preview {
    ContentView()
}
