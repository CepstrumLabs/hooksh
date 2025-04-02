#!/bin/bash

# Define the function for LLM-enhanced git commit
git_commit_llm() {
  # Check if a message was provided
  if [ -z "$1" ]; then
    echo "Usage: git-commit-llm -m \"message\""
    return 1
  fi

  # Get the commit message from the argument
  user_message="$1"

  # Check for OpenAI API key
  if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY environment variable is not set"
    return 1
  fi

  # Get the git diff (staged changes only)
  diff=$(git diff --cached)

  # If there's no diff, abort
  if [ -z "$diff" ]; then
    echo "No changes to commit."
    return 1
  fi

  # Check if jq is available
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required for JSON processing. Please install jq."
    return 1
  fi

  # Get a cleaner diff directly using git to avoid control characters
  # Use the staged changes but convert to a safer format
  clean_diff=$(git diff --cached --minimal | 
               tr -d '\000-\037' | 
               sed 's/[\\"`{}]//g' | 
               tr '\n' ' ' | 
               head -c 100000)
  
  # Clean the user message similarly
  clean_message=$(echo "$user_message" | tr -d '\000-\037' | sed 's/[\\"`{}]//g')

  # Create a safer JSON payload using a file
  tmp_file=$(mktemp)
  cat > "$tmp_file" << EOF
{
  "model": "gpt-4o-mini",
  "temperature": 0.2,
  "max_tokens": 100,
  "messages": [
    {
      "role": "user",
      "content": "Improve this Git commit message based on the following diff and conventional commit message guidelines(allowed types: docs: docs, feat: feat, fix: fix, perf: perf, refactor: refactor, style: style, test: test), return only a concise yet descriptive semantiucally correct commit message and nothing else:\n\nDiff: ${clean_diff}\n\nOriginal message: ${clean_message}"
    }
  ]
}
EOF

  # Use the file with curl to avoid shell escaping issues
  local llm_message=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d @"$tmp_file" | jq -r '.choices[0].message.content')
  
  # Clean up
  rm "$tmp_file"

  # Check if we got a valid message
  if [ -z "$llm_message" ]; then
    echo "Error: Could not get response from OpenAI API"
    return 1
  fi

  # Trim leading/trailing whitespace
  llm_message=$(echo "$llm_message" | xargs)
  
  # Simple header without a box
  echo -e "\n\033[1;32m------------------ 🤖 SUGGESTION ------------------\033[0m"
  
  # Command in bold green, message in bold white

  echo -e "\033[1;97m$llm_message\033[0m"
  
  # Simple footer
  echo -e "\033[1;32m----------------------------------------------------\033[0m"

#   Add a line saying : Proceed with the commit? (y/n)
  echo -e "\n\033[1;32mProceed with the commit? (y/n)\033[0m"
  read proceed
  if [ "$proceed" != "y" ]; then
    echo -e "\033[1;97mCommiting using original user message.\033[0m"
    
    # Create a simple box
    # Calculate box width based on message length (minimum 50 characters)
    box_content="git commit -m \"$user_message\""
    box_length=$((${#box_content} + 4)) # Add some padding
    [ $box_length -lt 50 ] && box_length=50  # Minimum width
    
    # Create the top border with the calculated length
    printf "\033[1;35m┌"
    printf "%${box_length}s" | tr " " "─"
    printf "┐\033[0m\n"
    
    # Create the message line with proper padding
    printf "\033[1;35m│\033[0m git commit -m \"\033[1;97m$user_message\033[0m\" "
    padding=$((box_length - ${#box_content} - 1))
    printf "%${padding}s\033[1;35m│\033[0m\n" ""
    
    # Create the bottom border with the calculated length
    printf "\033[1;35m└"
    printf "%${box_length}s" | tr " " "─"
    printf "┘\033[0m\n"
    
    command git commit -m "$user_message"
  else
    echo -e "\033[1;97mCommiting using 🤖 suggestion.\033[0m"
    
    # Create a simple box
    # Calculate box width based on message length (minimum 50 characters)
    box_content="git commit -m \"$llm_message\""
    box_length=$((${#box_content} + 4)) # Add some padding
    [ $box_length -lt 50 ] && box_length=50  # Minimum width
    
    # Create the top border with the calculated length
    printf "\033[1;35m┌"
    printf "%${box_length}s" | tr " " "─"
    printf "┐\033[0m\n"
    
    # Create the message line with proper padding
    printf "\033[1;35m│\033[0m git commit -m \"\033[1;97m$llm_message\033[0m\" "
    padding=$((box_length - ${#box_content} - 1))
    printf "%${padding}s\033[1;35m│\033[0m\n" ""
    
    # Create the bottom border with the calculated length
    printf "\033[1;35m└"
    printf "%${box_length}s" | tr " " "─"
    printf "┘\033[0m\n"
    
    command git commit -m "$llm_message"
  fi
  
}

# Define the function that overrides git command
git_override() {
  if [[ "$1" == "commit" && "$2" == "-m" ]]; then
    shift 2
    echo "Using git-commit-llm 🤖"
    git_commit_llm "$@"
  else
    command git "$@"
  fi
}

# Export the functions so they're available in the shell
export -f git_commit_llm
export -f git_override

# Define the alias that uses the override function
alias git='git_override'

# Check if this script is being sourced or executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Script is being executed directly
  if [ -z "$1" ]; then
    echo "This script can be used in two ways:"
    echo "1. Source it to override git command: source $(basename $0)"
    echo "2. Run it directly with a commit message: $(basename $0) \"your message\""
    exit 1
  fi
  
  # Execute the function directly with the provided arguments
  git_commit_llm "$1"
else
  # Script is being sourced - inform the user that git command is now enhanced
  echo "Git commit command has been enhanced with LLM capabilities."
  echo "Use 'git commit -m \"your message\"' as usual."
fi

