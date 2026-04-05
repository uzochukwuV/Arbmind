# Use official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Install system dependencies (wget and tar)
RUN apt-get update && apt-get install -y wget tar && rm -rf /var/lib/apt/lists/*

# Download and install Kraken CLI
RUN wget https://github.com/krakenfx/kraken-cli/releases/download/v0.3.0/kraken-cli-x86_64-unknown-linux-gnu.tar.gz \
    && tar -xzf kraken-cli-x86_64-unknown-linux-gnu.tar.gz \
    && chmod +x kraken-cli-x86_64-unknown-linux-gnu/kraken \
    && mv kraken-cli-x86_64-unknown-linux-gnu/kraken /usr/local/bin/ \
    && rm -rf kraken-cli-x86_64-unknown-linux-gnu.tar.gz kraken-cli-x86_64-unknown-linux-gnu

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose the dashboard API port
EXPOSE 8000

# Command to run the agent
CMD ["python", "main.py"]