#!/bin/bash


# Function to handle command not found errors
function command_not_found_handle() {
    local command="$1"
    
    # Skip if the command is empty
    if [ -z "$command" ]; then
        return 1
    fi
    
    # Check if OPENAI_API_KEY is set
    if [ -z "$OPENAI_API_KEY" ]; then
        echo "Error: OPENAI_API_KEY environment variable is not set"
        return 1
    fi
    
    # Escape the command for JSON
    local escaped_command=$(escape_json "$command")
    
    # Prepare the prompt for the LLM
    local prompt="The user typed '$command' in their terminal. This command was not found. Please help explain what might have gone wrong and suggest a correction. Keep the response concise and focused on terminal commands."
    
    # Make API call to OpenAI
    local response=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-3.5-turbo\",
            \"messages\": [{\"role\": \"user\", \"content\": \"$prompt\"}],
            \"temperature\": 0.7,
            \"max_tokens\": 150
        }")
    
    # Check if jq is available
    if ! command -v jq >/dev/null 2>&1; then
        echo "Warning: jq is not installed. Showing raw response:"
        echo "$response"
        return 1
    fi

    # Extract and format the content
    content=$(printf '%s' "$response" | jq -R -s 'fromjson | .choices[0].message.content' 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$content" ]; then
        echo -e "\n🤖 LLM Response:"
        # Remove quotes and interpret escape sequences
        echo -e "${content//\"/}"
    else
        echo "Error processing response. Response was:"
        echo "$response"
    fi
    echo
}
 

# Export the function so it's available to the shell
export -f command_not_found_handle

# Set up the command not found hook
if [ -n "$BASH_VERSION" ]; then
    # For Bash - use DEBUG trap to capture the command before execution
    function __capture_command() {
        local current_command="$BASH_COMMAND"
        # Store the command for the error handler
        export __last_command="$current_command"
    }
    
    # Set up the DEBUG trap to capture the command
    trap '__capture_command' DEBUG
    
    # Set up the error handler
    trap 'if [[ $? -eq 127 ]]; then command_not_found_handle "$__last_command"; fi' ERR   # 127 is the exit code for command not found
    trap 'if [[ $? -ne 0 ]]; then command_not_found_handle "$__last_command"; fi' ERR  # 0 is the exit code for success, trap if not 0
elif [ -n "$ZSH_VERSION" ]; then
    # For Zsh - use preexec hook to capture the command
    function __capture_command() {
        export __last_command="$1"
    }
    
    # Set up the preexec hook
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec __capture_command
    
    # Set up error handling hooks
    function __check_last_command() {
        if [[ $? -ne 0 ]]; then
            command_not_found_handle "$__last_command"
        fi
    }
    
    add-zsh-hook precmd __check_last_command
    
    # Set up the command not found handler
    function command_not_found_handler() {
        command_not_found_handle "$__last_command"
    }
fi 