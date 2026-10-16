
FROM maven:3.9.9-eclipse-temurin-17

WORKDIR /app

# Install Google Chrome
RUN apt-get update && apt-get install -y \
    ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
       | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/google-chrome

# Copy Maven configuration and source files
COPY pom.xml .
COPY testng.xml .
COPY src ./src
COPY webpage ./webpage

# Download dependencies
RUN mvn dependency:go-offline -B

# Run tests when the container starts
CMD ["mvn", "clean", "test"]
