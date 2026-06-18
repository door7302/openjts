#!/bin/bash
# Load config file and export as environment variables
if [ -f /etc/chronograf/config.ini ]; then
    while IFS='=' read -r key value; do
        # Skip empty lines and comments
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        # Remove leading/trailing whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        # Export as environment variable
        export "$key"="$value"
    done < /etc/chronograf/config.ini
fi

# Run chronograf with the configured environment
exec chronograf