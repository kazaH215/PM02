using System;

public class Request
{
    public int Id { get; set; }
    public int ClientId { get; set; }
    public int ProgrammerId { get; set; }
    public int ServiceId { get; set; }
    public DateTime CreatedDate { get; set; }
    public int StatusId { get; set; }
    public string Description { get; set; }
    public DateTime? DueDate { get; set; }
    public decimal Amount { get; set; }
}