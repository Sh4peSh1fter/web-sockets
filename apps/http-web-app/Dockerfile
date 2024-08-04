FROM python:3.12-slim

# Install curl
# RUN apk --no-cache add curl

# Set the working directory in the container
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY main.py .

# # Create a non-root user and switch to it
# RUN adduser --disabled-password --gecos '' appuser
# USER appuser

# Expose the port the app runs on
ARG PORT
EXPOSE $PORT

# # Health check
# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
#   CMD curl -f http://localhost:{PORT}/health || exit 1

# Run the application
CMD ["python", "main.py"]