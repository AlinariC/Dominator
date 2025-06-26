using System;
using System.Collections.Generic;
using System.Management;

public static class DeviceInfo
{
    public static object GetInfo()
    {
        return new
        {
            name = Environment.MachineName,
            last_check_in = DateTime.UtcNow.ToString("o"),
            user = Environment.UserName,
            uptime = TimeSpan.FromMilliseconds(Environment.TickCount64).ToString(),
            updates = GetInstalledUpdates()
        };
    }

    private static List<object> GetInstalledUpdates()
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
        catch
        {
        }
        return updates;
    }
}
