import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: DeviceListViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Refresh") {
                    Task { await viewModel.loadDevices() }
                }
            }
            List(viewModel.devices) { device in
                VStack(alignment: .leading) {
                    Text(device.name).font(.headline)
                    HStack {
                        Text("Last check-in: \(device.lastCheckIn)")
                        Spacer()
                        Text("User: \(device.user)")
                        Spacer()
                        Text("Uptime: \(device.uptime)")
                    }.font(.caption)
                }
            }
        }
        .padding()
        .task { await viewModel.loadDevices() }
    }
}

#Preview {
    ContentView()
        .environmentObject(DeviceListViewModel())
}
