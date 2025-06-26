import Foundation

struct Device: Identifiable, Codable {
    let id: UUID = UUID()
    let name: String
    let lastCheckIn: String
    let user: String
    let uptime: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case lastCheckIn = "last_check_in"
        case user
        case uptime
    }
}

@MainActor
class DeviceListViewModel: ObservableObject {
    @Published var devices: [Device] = []

    func loadDevices() async {
        guard let url = URL(string: "https://example.com/devices") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let devices = try JSONDecoder().decode([Device].self, from: data)
            self.devices = devices
        } catch {
            print("Failed to load devices: \(error)")
        }
    }
}
