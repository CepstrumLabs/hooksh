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
   git clone https://github.com/CepstrumLabs/hooksh
   cd hooksh
   ```

2. Set your OpenAI API key:
   Add this to your `.zshrc` or `.bashrc` for persistence.
   
   or for `zsh`:
   
   ```shell
   echo 'export OPENAI_API_KEY="sk-xxxxxxx"' >> ~/.zshrc
   ```

   For `bash`:
   ```shell
   echo 'export OPENAI_API_KEY="sk-xxxxxxx"' >> ~/.bashrc
   ```
3. Add to your shell configuration:
   
   For `zsh`:

   ```bash
   echo "source $(pwd)/llm-shell-tools.sh" >> ~/.zshrc
   ```

   For `bash`:

   ```bash
   echo "source $(pwd)/llm-shell-tools.sh" >> ~/.bashrc
   ```



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