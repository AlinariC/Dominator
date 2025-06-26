using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
builder.Host.UseWindowsService();

var app = builder.Build();

app.MapGet("/device", () => Results.Json(DeviceInfo.GetInfo()));

app.Run();
