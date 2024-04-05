//
//  PickupQueuePage.swift
//  GreenwealthPickup
//
//  Created by user1 on 21/02/24.
//

import SwiftUI

struct PickupQueuePage: View {
    
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var pickupId: Int
    
    var body: some View {
        VStack{
            if(pickupModel.hasAcceptedPickups || pickupModel.hasStartedPickups || pickupModel.hasCollectedPickups){
                ScrollView{
                    ForEach(pickupModel.startedPickups, id:\.id){ pickup in
                        Button(action:{
                            pickupId = pickup.id!
                            pageState = "ActionPage"
                        }){
                            VStack(spacing:15){
                                HStack{
                                    Text("#"+"\(pickup.id!)")
                                    Spacer()
                                    if(pickup.status == "canceled"){
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(.red)
                                    }
                                    else{
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(Color.primaryGreen)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                                Divider()
                                HStack{
                                    Image("demo")
                                        .resizable()
                                        .frame(width: 50,height: 50)
                                        .cornerRadius(5)
                                    VStack(alignment:.leading){
                                        Text("5 kgs")
                                        HStack(spacing:0){
                                            Text(pickup.date.formatted(date: .abbreviated,time: .omitted))
                                            Text(",")
                                                .padding(.trailing, 5)
                                            Text(pickup.startTime.formatted(date:.omitted,time: .shortened))
                                            Text("to")
                                                .padding(.horizontal, 5)
                                            Text(pickup.endTime.formatted(date:.omitted,time: .shortened))
        //        //                                Spacer()
                                        }
                                    }
                                    .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                }
                                Divider()
                                HStack{
                                    HStack{
                                        Text("Rate:")
                                        Spacer()
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                            }
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .padding(.vertical, 5)
                            .foregroundColor(.black)
                        }
                    }
                    ForEach(pickupModel.acceptedPickups, id:\.id){ pickup in
                        Button(action:{
                            pickupId = pickup.id!
                            pageState = "ActionPage"
                        }){
                            VStack(spacing:15){
                                HStack{
                                    Text("#"+"\(pickup.id!)")
                                    Spacer()
                                    if(pickup.status == "canceled"){
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(.red)
                                    }
                                    else{
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(Color.primaryGreen)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                                Divider()
                                HStack{
                                    Image("demo")
                                        .resizable()
                                        .frame(width: 50,height: 50)
                                        .cornerRadius(5)
                                    VStack(alignment:.leading){
                                        Text("5 kgs")
                                        HStack(spacing:0){
                                            Text(pickup.date.formatted(date: .abbreviated,time: .omitted))
                                            Text(",")
                                                .padding(.trailing, 5)
                                            Text(pickup.startTime.formatted(date:.omitted,time: .shortened))
                                            Text("to")
                                                .padding(.horizontal, 5)
                                            Text(pickup.endTime.formatted(date:.omitted,time: .shortened))
        //        //                                Spacer()
                                        }
                                    }
                                    .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                }
                                Divider()
                                HStack{
                                    HStack{
                                        Text("Rate:")
                                        Spacer()
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                            }
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .padding(.vertical, 5)
                            .foregroundColor(.black)
                        }
                    }
                    ForEach(pickupModel.collectedPickups, id:\.id){ pickup in
                        Button(action:{
                            pickupId = pickup.id!
                            pageState = "ActionPage"
                        }){
                            VStack(spacing:15){
                                HStack{
                                    Text("#"+"\(pickup.id!)")
                                    Spacer()
                                    if(pickup.status == "canceled"){
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(.red)
                                    }
                                    else{
                                        Text("\(pickup.status)".capitalized)
                                            .foregroundColor(Color.primaryGreen)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                                Divider()
                                HStack{
                                    Image("demo")
                                        .resizable()
                                        .frame(width: 50,height: 50)
                                        .cornerRadius(5)
                                    VStack(alignment:.leading){
                                        Text("5 kgs")
                                        HStack(spacing:0){
                                            Text(pickup.date.formatted(date: .abbreviated,time: .omitted))
                                            Text(",")
                                                .padding(.trailing, 5)
                                            Text(pickup.startTime.formatted(date:.omitted,time: .shortened))
                                            Text("to")
                                                .padding(.horizontal, 5)
                                            Text(pickup.endTime.formatted(date:.omitted,time: .shortened))
        //        //                                Spacer()
                                        }
                                    }
                                    .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                }
                                Divider()
                                HStack{
                                    HStack{
                                        Text("Rate:")
                                        Spacer()
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                        Image(systemName: "star")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                                .font(.system(size: 17,weight: .medium))
                            }
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .padding(.vertical, 5)
                            .foregroundColor(.black)
                        }
                    }
                }
            }
            else{
                EmptyPage()
            }
        }
        .background(Color.primaryBackground)
    }
}

struct previewPickupQueuePage: View {
    
    @StateObject var pickupModel = pickupsModel()
    @State var pageState: String = "QueuePage"
    @State var pickupId: Int = 0
    
    func test() async{
        try? await pickupModel.getAcceptedPickups(collectorID: 2)
    }
    
    var body: some View {
        PickupQueuePage(pickupModel: pickupModel, pageState: $pageState, pickupId: $pickupId)
            .task {
                await test()
            }
    }
}

#Preview {
    previewPickupQueuePage()
}
