#!/bin/bash

# Directory where your LLM shell tools are located
LLM_TOOLS_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Load command not found hook
if [ -f "$LLM_TOOLS_DIR/llm-hook.sh" ]; then
    source "$LLM_TOOLS_DIR/llm-hook.sh" > /dev/null
else
    echo "Warning: llm-hook.sh not found at $LLM_TOOLS_DIR"
fi

# Set up git commit LLM alias
if [ -f "$LLM_TOOLS_DIR/git-commit-llm.sh" ]; then
    source "$LLM_TOOLS_DIR/git-commit-llm.sh" > /dev/null
else
    echo "Warning: git-commit-llm.sh not found at $LLM_TOOLS_DIR"
fi

# Ensure the escape_json function is available for both tools
if ! type escape_json > /dev/null 2>&1; then
    function escape_json() {
        # Escape backslashes, double quotes, and newlines for JSON
        local content="$1"
        content="${content//\\/\\\\}"  # Backslashes
        content="${content//\"/\\\"}"  # Double quotes
        content="${content//	/\\t}"    # Tabs
        content="${content//
/\\n}"    # Newlines
        echo "$content"
    }
    export -f escape_json
fi

# Common setup for both tools - ensure OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Note: OPENAI_API_KEY is not set. LLM shell tools will use fallback behaviors."
    # You could even add a prompt here to set it:
    # read -p "Would you like to set your OpenAI API key now? (y/n): " choice
    # if [[ "$choice" == "y" ]]; then
    #     read -sp "Enter your OpenAI API key: " api_key
    #     echo "export OPENAI_API_KEY='$api_key'" >> ~/.bashrc  # or ~/.zshrc
    #     export OPENAI_API_KEY="$api_key"
    # fi
fi 