struct MapView: View {
    //    - State to control sheet.
    @State private var showUserBusinessAdd = false
    
    //    - State to control location text field string.
    @State  var location: String = ""
    
    // - Location Manager
    @State var locationManager = CLLocationManager()
        
    //    - State to control custom map location.
//  @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 178.30284, longitude: -72.29482), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))    
    func search() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response,
                  let longitude = response.mapItems.first?.placemark.coordinate.longitude,
                  let latitude = response.mapItems.first?.placemark.coordinate.latitude else {
                print(error?.localizedDescription ?? "This should be impossible")
                return
            }
          print(response.mapItems.first?.placemark.title ?? "No Placemarks")
            var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            self.coordinateRegion = coordinateRegion
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $coordinateRegion)
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    TextField("Please enter a zip code.",
                              text: $location,
                              onCommit:
                                {
                                    print("Committed.")
                                    search()
                                })

                    
                    Button(action: { self.showUserBusinessAdd = true } ) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showUserBusinessAdd) {
                        UserAddBusinessVM()
                    }
                    Button(action:
                            {
                                print("Current Location Button Tapped")
                            }) {
                        Image(systemName: "paperplane")
                    }
                }
                .background(Color.white)
                Spacer()
            }
        }
    }
}
