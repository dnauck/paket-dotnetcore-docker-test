IF NOT EXIST paket.lock (
    dotnet restore .paket
    START /WAIT .paket/paket install
)
dotnet restore src/MyWebApp
dotnet build src/MyWebApp

dotnet restore tests/MyWebApp.Tests
dotnet build tests/MyWebApp.Tests
dotnet test tests/MyWebApp.Tests

docker build --rm -f "Dockerfile" -t my-web-app:latest .