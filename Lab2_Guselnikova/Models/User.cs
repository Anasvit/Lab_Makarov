using System;
using System.Collections.Generic;

namespace Lab2_Guselnikova.Models;

public partial class User
{
    public int UserId { get; set; }

    public string Name { get; set; } = null!;

    public string Login { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string? Email { get; set; }

    public string? PhoneNumber { get; set; }

    public int? RoleId { get; set; }

    public virtual Role? Role { get; set; }
}
