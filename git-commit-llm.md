# Git Commit LLM 🚀  

An enhanced `git commit` command that leverages an LLM to suggest improved commit messages based on your staged changes. Quickly generate meaningful and descriptive messages with just one command!

## Features
- Mimics the `git commit -m "message"` syntax.
- Uses your initial commit message and the git diff to suggest a better message.
- Prompts you to accept or reject the suggestion.
- Seamlessly integrates with your existing Bash or Zsh configuration.

---

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/git-commit-llm.git
   cd git-commit-llm
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x git-commit-llm.sh
   ```

3. **Add the Alias to Your Shell Configuration**
   - For **Bash** (`~/.bashrc`):
     ```bash
     echo "alias git-commit-llm='bash /path/to/git-commit-llm.sh'" >> ~/.bashrc
     source ~/.bashrc
     ```
   - For **Zsh** (`~/.zshrc`):
     ```bash
     echo "alias git-commit-llm='bash /path/to/git-commit-llm.sh'" >> ~/.zshrc
     source ~/.zshrc
     ```

---

## Configuration

### OpenAI API Key
The script uses OpenAI’s API to generate improved commit messages. Set your API key as an environment variable:
```bash
export OPENAI_API_KEY="your_openai_api_key"
```
You can add this line to your `~/.bashrc` or `~/.zshrc` to make it persistent.

---

## Usage
Use the command just like a regular `git commit`:
```bash
git add .
git-commit-llm -m "initial commit"
```

You’ll be prompted with a suggested commit message:
```
Suggested commit message:
Add initial project structure and configuration

Use this message? (y/n):
```

- Press **`y`** to use the improved message.  
- Press **`n`** to use your original message.  

---

## Troubleshooting

### No Changes to Commit
If there are no staged changes, you’ll see:
```
No changes to commit.
```
Make sure to add changes before running the command:
```bash
git add .
```

### Missing API Key
If you haven't set the API key, the script will fail to make requests.  
Ensure your API key is correctly set:
```bash
echo $OPENAI_API_KEY
```

---

## Uninstallation
To remove the alias, simply delete it from your shell configuration:
- **Bash:**
  ```bash
  sed -i '/alias git-commit-llm/d' ~/.bashrc
  source ~/.bashrc
  ```
- **Zsh:**
  ```bash
  sed -i '/alias git-commit-llm/d' ~/.zshrc
  source ~/.zshrc
  ```
Then remove the script:
```bash
rm /path/to/git-commit-llm.sh
```
