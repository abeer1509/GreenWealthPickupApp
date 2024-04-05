//
//  ActionPage.swift
//  GreenwealthPickup
//
//  Created by user1 on 21/02/24.
//

import SwiftUI
import MapKit

struct ActionPage: View {
    
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var pickupId: Int
    
    @State var isPageLoading: Bool = true
    @State var isToastPresented: Bool = false
    @State var toastMessage: String = ""
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserLattitude: String = UserDefaults.standard.string(forKey: "LoggedUserLattitude") ?? ""
    @State private var loggedUserLongitude: String = UserDefaults.standard.string(forKey: "LoggedUserLongitude") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func getPageData() async{
        
        try? await pickupModel.getPickupInfo(pickupId: pickupId)
        
        if(pickupModel.responseStatus == 200){
            let latitude = Double((pickupModel.currentPickup.first!.lattitude as NSString).doubleValue)
            let longitude = Double((pickupModel.currentPickup.first!.longitude as NSString).doubleValue)
            
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
            isPageLoading = false
        }
        
    }
    
    func startOrder() async{
        
        isPageLoading.toggle()
        
        try? await pickupModel.startOrder(pickupId: pickupId)
        
        if(pickupModel.responseStatus == 200){
            try? await pickupModel.getPickupInfo(pickupId: pickupId)
            isPageLoading.toggle()
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
                                    pageState = "QueuePage"
                                }
                            }){
                                Image(systemName: "chevron.left")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(Color.primaryGreen)
                                    .font(.system(size: 17,weight: .semibold))
                            }
                            Spacer()
                            Text("Your ongoing order")
                                .font(.system(size: 17,weight: .bold))
                                .padding(.vertical,10)
                            Spacer()
                        }
                        .padding(.horizontal,40)
                        VStack{
                            ZStack{
                                VStack{
                                    Map(coordinateRegion: $region)
                                                .frame(height: 220)
                                }
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("PrimaryGreen"),lineWidth:2)
                                )
                                Button(action:{}){
                                    VStack(spacing:5){
                                        Text("2 5 4 7")
                                            .font(.system(size: 14,weight: .bold))
                                        Text("OTP")
                                            .font(.system(size: 12,weight: .regular))
                                    }
                                    .foregroundColor(.black)
                                }
                                .frame(width: 88,height: 54)
                                .background(.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color("PrimaryGreen"),lineWidth:2)
                                )
                                .offset(x:-123,y:65)
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,10)
                            ScrollView{
                                VStack(spacing:20){
                                    HStack{
                                        Image(systemName: "camera")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(Color.primaryGreen)
                                            .font(.system(size: 17,weight: .medium))
                                        Text("Approx 5 kgs")
                                            .font(.system(size: 17, weight: .medium))
                                        Spacer()
                                        if(isLogged){
                                            AsyncImage(url: URL(string: pickupModel.currentPickup.first!.imageURL)) { image in
                                                image.resizable()
                                            } placeholder: {
                                            ProgressView()
                                        }
                                                .frame(width: 50,height: 50)
                                                .cornerRadius(5)
                                        }
                                        else{
                                            Image("demo")
                                                .frame(width: 50,height: 50)
                                                .cornerRadius(5)
                                        }
                                    }
                                    Divider()
                                    HStack{
                                        Image(systemName: "trash")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(Color.primaryGreen)
                                            .font(.system(size: 17,weight: .medium))
                                        if(isLogged){
                                            Text("\(pickupModel.currentPickup.first!.categories)")
                                                .font(.system(size: 17, weight: .medium))
                                        }
                                        else{
                                            Text("Paper,Plastic")
                                                .font(.system(size: 17, weight: .medium))
                                        }
                                        Spacer()
                                    }
                                    Divider()
                                    HStack{
                                        Image(systemName: "location")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(Color.primaryGreen)
                                            .font(.system(size: 17,weight: .medium))
                                        if(isLogged){
                                            Text("\(pickupModel.currentPickup.first!.address)")
                                                .font(.system(size: 17, weight: .medium))
                                        }
                                        else{
                                            Text("SRM University")
                                                .font(.system(size: 17, weight: .medium))
                                        }
                                        Spacer()
                                    }
                                    Divider()
                                    HStack{
                                        Image(systemName: "calendar")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(Color.primaryGreen)
                                            .font(.system(size: 17,weight: .medium))
                                        HStack(spacing:5){
                                            if(isLogged){
                                                Text(pickupModel.currentPickup.first!.date.formatted(date: .abbreviated,time: .omitted))
                                                Text(",")
                                                Text(pickupModel.currentPickup.first!.startTime.formatted(date:.omitted,time: .shortened))
                                                Text("to")
                                                Text(pickupModel.currentPickup.first!.endTime.formatted(date:.omitted,time: .shortened))
                                            }
                                            else{
                                                Text(Date.now.formatted(date: .abbreviated,time: .omitted))
                                                Text(",")
                                                Text(Date.now.formatted(date:.omitted,time: .shortened))
                                                Text("to")
                                                Text(Date.now.formatted(date:.omitted,time: .shortened))
                                            }
            //                                Spacer()
                                        }
                                        .font(.system(size: 17, weight: .medium))
            //                            Text("Jan 23, 9:40am to 11:40am")
            //                                .font(.system(size: 17, weight: .medium))
                                        Spacer()
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                HStack{
                                    Text("Estimated price you receive")
                                    Spacer()
                                    HStack{
                                        Image(systemName: "indianrupeesign")
                                            .symbolRenderingMode(.hierarchical)
                                        Text("200")
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                if(pickupModel.currentPickup.first!.status != "completed" ){
                                    if(pickupModel.currentPickup.first!.startTime < Date.now){
                                        Button(action:{
                                            Task{
                                                if(pickupModel.currentPickup.first!.status == "accepted"){
                                                    await startOrder()
                                                }
                                                else{
                                                    pageState = "VerificationPage"
                                                }
                                                //await acceptOrder()
                                            }
                                        }){
                                            if(pickupModel.currentPickup.first!.status == "accepted"){
                                                Text("Start Order")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.primaryGreen)
                                                    .cornerRadius(10)
                                            }
                                            else if(pickupModel.currentPickup.first!.status == "started"){
                                                Text("Complete Order")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.primaryGreen)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                    }
                                    else{
                                        Button(action:{
                                            Task{
                                                if(pickupModel.currentPickup.first!.status == "accepted"){
                                                    await startOrder()
                                                }
                                                else{
                                                    pageState = "VerificationPage"
                                                }
                                                //await acceptOrder()
                                            }
                                        }){
                                            if(pickupModel.currentPickup.first!.status == "accepted"){
                                                Text("Start Order")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.primaryGreen.opacity(0.75))
                                                    .cornerRadius(10)
                                            }
                                            else if(pickupModel.currentPickup.first!.status == "started"){
                                                Text("Complete Order")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.primaryGreen)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .disabled(true)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .background(Color.primaryBackground)
        .task {
            await getPageData()
        }
    }
}

struct previewActionPage: View {
    
    @StateObject var pickupModel = pickupsModel()
    @State var pageState: String  = "ActionPage"
    @State var pickupId: Int = 4
    
    var body: some View {
        ActionPage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
    }
}

#Preview {
    previewActionPage()
}
