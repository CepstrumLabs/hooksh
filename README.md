# LLM Shell Tools

A collection of shell tools that enhance your command line experience using Large Language Models.

## Tools Included

### 1. Command Not Found Hook 🔍

This hook intercepts "command not found" errors and uses an LLM to provide helpful suggestions about what might have gone wrong and how to fix it.

### 2. Git Commit LLM 🚀  

An enhanced `git commit` command that leverages an LLM to suggest improved commit messages based on your staged changes.

## Prerequisites

- OpenAI API key
- Bash or Zsh shell
- `curl` command-line tool
- `jq` for JSON parsing

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/llm-shell-tools.git
   cd llm-shell-tools
   ```

2. Make the scripts executable:
   ```bash
   chmod +x llm-hook.sh git-commit-llm.sh
   ```

3. Create a loader script (optional):
   ```bash
   cp llm-shell-tools.sh.example llm-shell-tools.sh
   # Edit the file to set your correct paths
   ```

4. Add to your shell configuration:
   ```bash
   # Add to .bashrc or .zshrc:
   source /path/to/llm-shell-tools.sh
   # Or source each tool individually:
   source /path/to/llm-hook.sh
   alias gcai="bash /path/to/git-commit-llm.sh"
   ```

5. Set your OpenAI API key:
   ```bash
   export OPENAI_API_KEY='your-api-key-here'
   ```
   Add this to your `.bashrc` or `.zshrc` for persistence.

## Usage

### Command Not Found Hook

Once installed, this works automatically when you type a non-existent command:

```bash
$ git sttus
🤖 LLM Response:
It seems you meant to type 'git status' instead of 'git sttus'. The 'status' command shows the current state of your git repository.
```

### Git Commit LLM

Use the `gcai` alias instead of the regular `git commit`:

```bash
$ git add .
$ gcai -m "fix login bug"

Suggested commit message:
fix(auth): resolve user login failure when using special characters in password

Use this message? (y/n): y
[main 3f7e12a] fix(auth): resolve user login failure when using special characters in password
 2 files changed, 15 insertions(+), 3 deletions(-)
```

## Configuration

Both tools use the same OpenAI API key. You can customize the model and other parameters by editing the respective scripts.

### LLM-Hook Configuration

Edit `llm-hook.sh` to change:
- The LLM model (default: gpt-3.5-turbo)
- Temperature setting
- Max token limit for responses

### Git Commit LLM Configuration

Edit `git-commit-llm.sh` to change:
- The LLM model
- Prompt format for commit message suggestions
- Token limits for commit messages

## Notes

- Both tools require an active internet connection
- They use OpenAI's API, which may incur costs depending on your usage
- The tools work with both Bash and Zsh shells

## Troubleshooting

### No OpenAI API Key

If you see: 