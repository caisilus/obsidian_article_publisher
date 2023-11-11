# About

This is a simple ruby script for publishing Obsidian documents as md document on docsify. It assumes you should make a PR to GitHub repository to deploy your article.

# Requirements

1. Ruby 3.2.2

# Setup

1. Create `settings.yml` and fill it with your obsidian vault(change path below to your obsidian vault path):

```yaml
articles_folder: C:/documents/Obsidian vault
```
2. Run
```bash
bundle install
```

# Usage
Run `main.rb` with the name of the article you want to publish

```bash
ruby main.rb "My new article"
```
