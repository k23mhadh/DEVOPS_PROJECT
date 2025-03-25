# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Define build arguments for platform and architecture
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

# Set the working directory
WORKDIR /src

# Copy the csproj file first and restore dependencies
# This creates a layer that won't change unless the csproj file changes
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code
COPY . ./

# Publish the application
RUN dotnet publish -c release -o /app --self-contained false --no-restore

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
# Set the working directory
WORKDIR /app
# Copy the published application from the build stage
COPY --from=build /app .
# Set the entry point to run the worker application
ENTRYPOINT ["dotnet", "Worker.dll"]