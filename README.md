# LLM Command Not Found Hook

This script provides a shell hook that intercepts "command not found" errors and uses an LLM (OpenAI's GPT-3.5) to provide helpful suggestions about what might have gone wrong and how to fix it.

## Prerequisites

- OpenAI API key
- Bash or Zsh shell
- `curl` command-line tool

## Installation

1. Clone this repository or download the `llm-hook.sh` script
2. Make the script executable:
   ```bash
   chmod +x llm-hook.sh
   ```
3. Add the following line to your `.bashrc` or `.zshrc`:
   ```bash
   source /path/to/llm-hook.sh
   ```
4. Set your OpenAI API key as an environment variable:
   ```bash
   export OPENAI_API_KEY='your-api-key-here'
   ```
   You can add this line to your `.bashrc` or `.zshrc` as well.

## Usage

Once installed, whenever you type a command that doesn't exist, the hook will automatically:
1. Intercept the error
2. Send the command to the LLM
3. Display a helpful response explaining what might have gone wrong and suggesting corrections

Example:
```bash
$ git sttus
🤖 LLM Response:
It seems you meant to type 'git status' instead of 'git sttus'. The 'status' command shows the current state of your git repository.
```

## Notes

- The hook requires an active internet connection to work
- It uses OpenAI's GPT-3.5 API, which may incur costs depending on your usage
- The response is limited to 150 tokens to keep it concise
- The hook works with both Bash and Zsh shells 