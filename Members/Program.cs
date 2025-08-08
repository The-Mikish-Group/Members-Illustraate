using TaskStatus = Members.Models.TaskStatus;
using Members.Data;
using Members.Filters;
using Members.Models;
using Members.Services;
using Microsoft.AspNetCore.DataProtection; // Added for Data Protection
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure; // For IActionContextAccessor and ActionContextAccessor
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Register Syncfusion license
string SYNCFUSION_KEY = Environment.GetEnvironmentVariable("SYNCFUSION_KEY")!;
Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense(SYNCFUSION_KEY);

// Retrieve connection string from environment variables
string DB_SERVER = Environment.GetEnvironmentVariable("DB_SERVER_ILLUSTRATE")!;
string DB_USER = Environment.GetEnvironmentVariable("DB_USER_ILLUSTRATE")!;
string DB_PASSWORD = Environment.GetEnvironmentVariable("DB_PASSWORD_ILLUSTRATE")!;
string DB_NAME = Environment.GetEnvironmentVariable("DB_NAME_ILLUSTRATE")!;
if (string.IsNullOrEmpty(DB_SERVER) || string.IsNullOrEmpty(DB_USER) || string.IsNullOrEmpty(DB_PASSWORD) || string.IsNullOrEmpty(DB_NAME))
{
    // Handle the error: Log, throw an exception, or provide a default value
    throw new InvalidOperationException("Database environment variables (DB_SERVER_ILLUSTRATE, DB_USER_ILLUSTRATE, DB_PASSWORD_ILLUSTRATE, or DB_NAME_ILLUSTRATE) are not set.");
}
string connectionString = $"Data Source={DB_SERVER};Initial Catalog={DB_NAME};User Id={DB_USER};Password={DB_PASSWORD}";

// Add services for view rendering to string
builder.Services.AddHttpContextAccessor();
builder.Services.AddSingleton<IActionContextAccessor, ActionContextAccessor>();

// Configure DbContext with retry-on-failure and connection string from env vars
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        connectionString,
        sqlServerOptions => sqlServerOptions.EnableRetryOnFailure()
    )
);

// Add DbContext for Data Protection
builder.Services.AddDbContext<DataProtectionKeyDbContext>(options =>
    options.UseSqlServer(
        connectionString,
        sqlServerOptions => sqlServerOptions.EnableRetryOnFailure()
    )
);

// Configure Data Protection to use Entity Framework Core store
builder.Services.AddDataProtection()
    .PersistKeysToDbContext<DataProtectionKeyDbContext>()
    .SetApplicationName("MembersApplication"); // Unique name for the application   

builder.Services.AddDatabaseDeveloperPageExceptionFilter();
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>();

// Register IEmailSender and EmailService
builder.Services.AddTransient<IEmailSender, EmailService>();
builder.Services.AddTransient<EmailService>();

// Register Color filters
builder.Services.AddScoped<LoadDynamicColorsFilter>();
builder.Services.AddScoped<RazorPageLoadColorsFilter>();

// Register the Task Management Service
builder.Services.AddScoped<ITaskManagementService, TaskManagementService>();

// Apply filters globally to both MVC and Razor Pages
builder.Services.Configure<MvcOptions>(options =>
{
    options.Filters.Add<LoadDynamicColorsFilter>();
    options.Filters.Add<RazorPageLoadColorsFilter>();
});

builder.Services.AddControllersWithViews()
    .AddViewComponentsAsServices();

builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapStaticAssets();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Info}/{action=Index}/{id?}")
    .WithStaticAssets();

app.MapRazorPages()
    .WithStaticAssets();

//Create the Roles if they have been deleted.
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    string[] roles = ["Admin", "Member", "Manager"];
    foreach (var roleName in roles)
    {
        var roleExist = await roleManager.RoleExistsAsync(roleName);
        if (!roleExist)
        {
            await roleManager.CreateAsync(new IdentityRole(roleName));
        }
    }
}

// Create the Administrator Account if it has been deleted.
using (var scope = app.Services.CreateScope())
{
    var UserManager = scope.ServiceProvider.GetRequiredService<UserManager<IdentityUser>>();
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>(); // Get the ApplicationDbContext
    string ADMIN_EMAIL = Environment.GetEnvironmentVariable("ADMIN_EMAIL_ILLUSTRATE")!;
    string ADMIN_PASSWORD = Environment.GetEnvironmentVariable("ADMIN_PASSWORD_ILLUSTRATE")!;
    if (string.IsNullOrEmpty(ADMIN_EMAIL) || string.IsNullOrEmpty(ADMIN_PASSWORD))
    {
        throw new InvalidOperationException("ADMIN_EMAIL or ADMIN_PASSWORD environment variables are not set.");
    }
    var adminUser = await UserManager.FindByEmailAsync(ADMIN_EMAIL);
    if (adminUser == null)
    {
        adminUser = new IdentityUser
        {
            UserName = ADMIN_EMAIL,
            Email = ADMIN_EMAIL,
            EmailConfirmed = true,
            PhoneNumber = "(217) 371-8041" // Set the Cell Phone number in AspNetUsers
        };
        var createResult = await UserManager.CreateAsync(adminUser, ADMIN_PASSWORD);
        if (createResult.Succeeded)
        {
            await UserManager.AddToRoleAsync(adminUser, "Admin");
            // Update PhoneNumber if it's not already set
            if (string.IsNullOrEmpty(adminUser.PhoneNumber))
            {
                adminUser.PhoneNumber = "(217) 371-8041";
                await UserManager.UpdateAsync(adminUser);
            }
            // Update UserProfile
            var adminProfile = await dbContext.UserProfile.FirstOrDefaultAsync(up => up.UserId == adminUser.Id);
            if (adminProfile == null)
            {
                adminProfile = new UserProfile
                {
                    UserId = adminUser.Id,
                    FirstName = "An",
                    LastName = "Administrator",
                    AddressLine1 = "1042 N Brainerd",
                    City = "Avon Park",
                    State = "FL",
                    ZipCode = "33825",
                    HomePhoneNumber = "(123) 456-7890",
                    User = adminUser
                };
                dbContext.UserProfile.Add(adminProfile);
            }
            else
            {
                adminProfile.FirstName = "An";
                adminProfile.LastName = "Administrator";
                adminProfile.AddressLine1 = "1042 N Brainerd";
                adminProfile.City = "Avon Park";
                adminProfile.State = "FL";
                adminProfile.ZipCode = "33825";
                // You can choose to update HomePhoneNumber here if needed
            }
            await dbContext.SaveChangesAsync();
        }
        else
        {
            var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
            foreach (var error in createResult.Errors)
            {
                logger.LogError("Error creating admin user: {Description}", error.Description);
            }
            throw new Exception("Failed to create admin user.");
        }
    }
    else
    {
        // Do Nothing!
    }
}

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var logger = services.GetRequiredService<ILogger<Program>>();
    try
    {
        logger.LogInformation("Seeding database...");
        var context = services.GetRequiredService<Members.Data.ApplicationDbContext>();
        var cssPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "css", "site-colors.css");
        Members.Data.ColorVarSeeder.SeedAsync(context, cssPath).Wait();
        logger.LogInformation("Database seeding complete.");
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "An error occurred while seeding the database.");
    }
}

app.Run();