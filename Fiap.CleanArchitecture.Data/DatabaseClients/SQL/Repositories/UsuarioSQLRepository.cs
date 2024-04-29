﻿using Dapper;
using Fiap.CleanArchitecture.Data.DatabaseClients.SQL.Scripts;
using Fiap.CleanArchitecture.Entity.Entities;
using Fiap.CleanArchitecture.Util;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Fiap.CleanArchitecture.Data.DatabaseClients.SQL.Repositories
{
    public class UsuarioSQLRepository : Repository
    {
        private readonly IConfiguration _configuration;

        public UsuarioSQLRepository(IConfiguration configuration) : base(configuration)
        {
            _configuration = configuration;
        }

        public string GerarToken(Usuario usuario)
        {
            bool autenticado = false;

            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.GerarToken;

                var param = new DynamicParameters();

                param.Add("@EMAIL", usuario.Email, DbType.AnsiString, ParameterDirection.Input, 100);
                param.Add("@SENHA", usuario.Senha, DbType.AnsiString, ParameterDirection.Input, 20);
                autenticado = conn.QuerySingle<bool>(sql, param);
            }

            if (!autenticado)
                throw new Exception("Erro ao autenticar o usuário, por favor, tente novamente!");

            var expires = int.Parse(_configuration.GetSection("Authentication:ExpireTimeInHour").Value);
            var secret = _configuration.GetSection("Authentication:Secret").Value;
            var key = Encoding.UTF8.GetBytes(secret);

            //var claimsInfo = "buscar infos para repassar no token";

            var claims = new List<Claim>();

            //foreach (var claim in claimsInfo)
            //    claims.Add(new Claim(claimType, claimValue));

            var tokenDescriptor = new SecurityTokenDescriptor()
            {
                Audience = Crypto.Encode(usuario.Email),
                Issuer = "API-Fiap.CleanArchitecture",
                Subject = new ClaimsIdentity(claims, "Custom"),
                Expires = DateTime.UtcNow.AddHours(expires),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature,
                    SecurityAlgorithms.Sha256Digest)
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        public IEnumerable<Usuario> BuscarTodos()
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.BuscarTodos;

                var result = conn.Query<Usuario>(sql, commandTimeout: Timeout);

                return result;
            }
        }

        public Usuario BuscarPorId(int id)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.BuscarPorId;

                var param = new DynamicParameters();

                param.Add("@ID", id, DbType.Int32, ParameterDirection.Input);

                var result = conn.QueryFirstOrDefault<Usuario>(sql, param, commandTimeout: Timeout);

                return result;
            }
        }

        public void Criar(Usuario usuario)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.Criar;

                var param = new DynamicParameters();

                param.Add("@EMAIL", usuario.Email, DbType.AnsiString, ParameterDirection.Input, 100);
                param.Add("@SENHA", usuario.Senha, DbType.AnsiString, ParameterDirection.Input, 20);

                conn.Execute(sql, param, commandTimeout: Timeout);
            }
        }

        public Usuario Alterar(Usuario usuario)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.Alterar;

                var param = new DynamicParameters();

                param.Add("@ID", usuario.Id, DbType.Int32, ParameterDirection.Input);
                param.Add("@EMAIL", usuario.Email, DbType.AnsiString, ParameterDirection.Input, 100);

                conn.Execute(sql, param, commandTimeout: Timeout);
            }

            return BuscarPorId(usuario.Id);
        }

        public void Excluir(int id)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                var sql = UsuarioSQLScript.Excluir;

                var param = new DynamicParameters();

                param.Add("@ID", id, DbType.Int32, ParameterDirection.Input);

                conn.Execute(sql, param, commandTimeout: Timeout);
            }
        }
    }
}
