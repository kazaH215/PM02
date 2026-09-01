using System.Collections.Generic;
using System.Reflection.Emit;
using System.Runtime.Remoting.Contexts;
using Microsoft.EntityFrameworkCore;
using ServiceDeskAPI.Models; // Проверьте пространство имён! Оно должно совпадать с вашим проектом.

namespace ServiceDeskAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Client> Clients { get; set; }
        public DbSet<Programmer> Programmers { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<Status> Statuses { get; set; }
        public DbSet<Request> Requests { get; set; }
        public DbSet<History> Histories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Связи
            modelBuilder.Entity<Request>()
                .HasOne(r => r.Client)
                .WithMany()
                .HasForeignKey(r => r.ClientId);

            modelBuilder.Entity<Request>()
                .HasOne(r => r.Programmer)
                .WithMany()
                .HasForeignKey(r => r.ProgrammerId);

            modelBuilder.Entity<Request>()
                .HasOne(r => r.Service)
                .WithMany()
                .HasForeignKey(r => r.ServiceId);

            modelBuilder.Entity<Request>()
                .HasOne(r => r.Status)
                .WithMany()
                .HasForeignKey(r => r.StatusId);
        }
    }
}