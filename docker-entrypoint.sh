#!/bin/sh

# Set error handling
set -e

# Configuration
MAX_RETRIES=30
RETRY_INTERVAL=2

# Function to print timestamped messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if database is ready
wait_for_db() {
    local retries=0
    log "Waiting for database to be ready..."
    
    while [ $retries -lt $MAX_RETRIES ]; do
        if npx prisma db execute --stdin > /dev/null 2>&1 <<-SQL
            SELECT 1;
SQL
        then
            log "Database is ready!"
            return 0
        fi
        
        retries=$((retries + 1))
        log "Database is not ready - attempt $retries/$MAX_RETRIES"
        sleep $RETRY_INTERVAL
    done
    
    log "Error: Database connection timeout after $MAX_RETRIES attempts"
    return 1
}

# Main execution
main() {
    # Wait for database
    if ! wait_for_db; then
        log "Failed to connect to database"
        exit 1
    fi

    # Run database migrations
    log "Running database migrations..."
    if npx prisma migrate deploy; then
        log "Database migrations completed successfully"
    else
        log "Error: Database migration failed"
        exit 1
    fi

    # Execute the main command
    log "Starting application..."
    exec "$@"
}

# Run main function
main "$@"