//
//  ContentView.swift
//  Birthdays
//
//  Created by Scholar on 7/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var friends : [Friend]
    //= [Friend(name: "Oteiya", birthday: .now), Friend(name: "Orienna", birthday: Date(timeIntervalSince1970: 20))]
    
    @Environment(\.modelContext) private var context
    @State private var newName = ""
    @State private var newBirthday = Date.now
    @State private var selectedFriend: Friend?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends) { friend in
                    HStack {
                        HStack {
                            Text(friend.name)
                            Spacer()
                            Text(friend.birthday, format: .dateTime.month(.wide).day().year())
                        }
                        .onTapGesture {
                            selectedFriend = friend
                        }
                    }//hstack
                }
                    .onDelete(perform: deleteFriend)
                }//friend in
                .navigationTitle("Birthdays")
                .sheet(item: $selectedFriend) { friend in
                    NavigationStack {
                        EditFriendView(friend: friend)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    VStack(alignment: .center, spacing: 20) {
                        Text("New Birthday")
                            .font(.headline)
                        DatePicker(selection: $newBirthday, in: Date.distantPast...Date.now, displayedComponents: .date) {
                            TextField("Name", text: $newName)
                                .textFieldStyle(.roundedBorder)
                        }
                        Button("Save") {
                            let newFriend = Friend(name: newName, birthday: newBirthday)
                            //friends.append(newFriend)
                            context.insert(newFriend)
                            newName = ""
                            newBirthday = .now
                        }
                        .bold()
                    }
                    .padding()
                    .background(.bar)
                }
            }
        
    }//body
        
        func deleteFriend(at offsets: IndexSet) {
            for index in offsets {
                let friendToDelete = friends[index]
                context.delete(friendToDelete)
            }
        }
}//struct
    
    
#Preview {
    ContentView()
            .modelContainer(for: Friend.self, inMemory: true)
    }

