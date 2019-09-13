FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY ["GICMicro/GICMicro.csproj", "GICMicro/"]
RUN dotnet restore "GICMicro/GICMicro.csproj"
COPY . .
WORKDIR "/src/GICMicro"
RUN dotnet build "GICMicro.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "GICMicro.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "GICMicro.dll"]