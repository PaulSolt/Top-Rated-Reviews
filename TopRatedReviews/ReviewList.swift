//
//  ReviewList.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI


struct ReviewList: View {
    //    var reviews: [Review] = appReviewTestData  // Prototype
    @EnvironmentObject var reviewStore: AppReviewStore
    
    var blankAppVersion = AppVersion(reviews: [], version: "0.0.0")
    
    var body: some View {
        
        TabView {
            NavigationView {
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(AppVersion.allVersions)
                        
                        StarRatingsView(appVersion: reviewStore.stats.allVersions)
                            .padding(.all, 8)
                    }
                    .padding(.bottom, 16)
                    
                    List {
                        ForEach(reviewStore.stats.allVersions.reviews) { review in
                            ReviewRow(review: review)
                        }
                    }
                }
                .navigationBarTitle(Text("All Reviews"))
            }
    
            .tabItem {
                Text("All Versions")
            }
        
            NavigationView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Version: \(reviewStore.stats.currentVersion())")
                        StarRatingsView(appVersion: reviewStore.stats.currentAppVersion ?? blankAppVersion)
                            .padding(.all, 8)
                    }.padding(.bottom, 16)
                    List {
                        
                        ForEach(reviewStore.stats.currentAppVersion?.reviews ?? blankAppVersion.reviews) { review in
                            ReviewRow(review: review)
                        }
                    }
                    
                }
                .navigationBarTitle(Text("Current Reviews"))
                
            }
            .tabItem {
                Text("Current Version")
            }
            
            NavigationView {
                
                List(reviewStore.stats.sortedAppVersions().reversed(), id: \.version) { version in

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Version: \(version.version)")

                        StarRatingsView(appVersion: version)
                            .padding(.all, 8)
                    }.padding()
                }//.padding(.all, 20)
                
                .navigationBarTitle(Text("App Health"))

                

            }.tabItem {
                Text("App Health")
            }
            
        }.onAppear {
            print("Fetch Reviews")
            self.fetch()
        }
    }
    
    private func fetch() {
        
//        reviewStore.fetchReviews(for: appId, ordering: ordering) // NYTimes
    }
}

struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList()
            .environmentObject(
                AppReviewStore(service: AppReviewService()))
    }
}
