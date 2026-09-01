using System;

public class History
{
    public int Id { get; set; }
    public int RequestId { get; set; }
    public string User { get; set; }
    public string Action { get; set; }
    public DateTime ChangeDate { get; set; }
    public string OldStatus { get; set; }
    public string NewStatus { get; set; }
}