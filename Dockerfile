FROM openjdk:8-jre-alpine

# Set default thumbnail size
ENV TN_SIZE=150

# Install bash (נדרש בשביל הסקריפט)
RUN apk add --no-cache bash

# Create directories
RUN mkdir -p /app /pics

# Copy all necessary files
COPY target/thumbnailer.jar /app/
COPY target/lib/ /app/lib/
COPY thumbnail.sh /app/
COPY entrypoint.sh /app/

# Make scripts executable
RUN chmod +x /app/thumbnail.sh /app/entrypoint.sh

WORKDIR /app

VOLUME ["/pics"]

ENTRYPOINT ["/app/entrypoint.sh"]