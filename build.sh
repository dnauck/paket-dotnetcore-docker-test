#!/bin/sh
if [ ! -e "paket.lock" ]
then
    dotnet restore .paket
    .paket/paket install
fi
dotnet restore src/MyWebApp
dotnet build src/MyWebApp

dotnet restore tests/MyWebApp.Tests
dotnet build tests/MyWebApp.Tests
dotnet test tests/MyWebApp.Tests

docker build --rm -f "Dockerfile" -t my-web-app:latest .