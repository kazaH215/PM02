public class User
{
    public int Id { get; set; }
    public string Login { get; set; }
    public string PasswordHash { get; set; }
    public string Role { get; set; } // Admin, Manager, Programmer, Client
    public int? ProgrammerId { get; set; }
    public int? ClientId { get; set; }
}