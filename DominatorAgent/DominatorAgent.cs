using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;

public class DominatorAgent : BackgroundService
{
    private readonly HttpClient _httpClient = new HttpClient();
    private readonly string _logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "agent.log");

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var data = new
                {
                    machineName = Environment.MachineName,
                    user = Environment.UserName,
                    uptime = TimeSpan.FromMilliseconds(Environment.TickCount64).ToString(),
                    updates = GetInstalledUpdates()
                };
                var json = JsonSerializer.Serialize(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await _httpClient.PostAsync("https://example.com/checkin", content, stoppingToken);
                response.EnsureSuccessStatusCode();
                Log($"Sent check-in at {DateTime.UtcNow}. Status: {response.StatusCode}");
            }
            catch (Exception ex)
            {
                Log($"Error during check-in: {ex.Message}");
            }

            try
            {
                await Task.Delay(TimeSpan.FromSeconds(60), stoppingToken);
            }
            catch (TaskCanceledException)
            {
            }
        }
    }

    private List<object> GetInstalledUpdates()
    {
        var updates = new List<object>();
        try
        {
            using var searcher = new ManagementObjectSearcher("SELECT HotFixID, Description FROM Win32_QuickFixEngineering");
            foreach (ManagementObject update in searcher.Get())
            {
                var hotFix = update["HotFixID"]?.ToString();
                var desc = update["Description"]?.ToString();
                updates.Add(new { name = desc, kb = hotFix });
            }
        }
        catch (Exception ex)
        {
            Log($"Error retrieving updates: {ex.Message}");
        }
        return updates;
    }

    private void Log(string message)
    {
        try
        {
            File.AppendAllText(_logPath, $"[{DateTime.Now}] {message}{Environment.NewLine}");
        }
        catch
        {
        }
    }
}
