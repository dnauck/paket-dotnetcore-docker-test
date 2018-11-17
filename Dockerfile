FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS paket-bootstrap
COPY [".paket/paket.bootstrapper.proj", ".paket/"]
COPY [".paket/paket.bootstrapper.props", ".paket/"]
COPY [".paket/paket.bootstrapper.exe.config", ".paket/"]
RUN dotnet restore .paket


#FROM paket-bootstrap AS paket-restore
#COPY [ "paket.dependencies", "."]
#COPY [ "paket.lock", "."]
#RUN .paket/paket restore


FROM paket-bootstrap AS build
COPY [ "paket.dependencies", "."]
COPY [ "paket.lock", "."]
COPY [ ".paket/Paket.Restore.targets", ".paket/"]
COPY [ "src", "src/"]
WORKDIR "/src/MyWebApp"
RUN dotnet build "MyWebApp.fsproj" -c Release -o /app


FROM build AS publish
RUN dotnet publish "MyWebApp.fsproj" -c Release -o /app


FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "MyWebApp.dll"]
