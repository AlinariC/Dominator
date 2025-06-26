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

    private var agentHosts: [String] {
        let env = ProcessInfo.processInfo.environment["AGENT_HOSTS"] ?? ""
        return env.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    func loadDevices() async {
        var loaded: [Device] = []
        for host in agentHosts {
            guard let url = URL(string: "\(host)/device") else { continue }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let device = try JSONDecoder().decode(Device.self, from: data)
                loaded.append(device)
            } catch {
                print("Failed to load device from \(host): \(error)")
            }
        }
        self.devices = loaded
    }
}
