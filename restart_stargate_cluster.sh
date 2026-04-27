docker run -e "ACCEPT_EULA=Y" \
           -e "MSSQL_SA_PASSWORD=Stargate_DBA_2026!" \
           -e "MSSQL_MEMORY_LIMIT_MB=4096" \
           --name bloomberg_sql_dev \
           -p 1433:1433 \
           --restart always \
           -d mcr.microsoft.com/mssql/server:2025-latest
