EMAIL=fpaoline@redhat.com

# Create a new ssh key for signing / follow prompts
# Even if you want to use the same key for authentication, you must upload it as a "Signing Key".
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/github_signing_ed25519


eval "$(ssh-agent -s)"
# Add the key to your sshagent, if you are using one, to prevent prompting on each commit.
# Commands may vary depending on your setup.
ssh-add /home/$(whoami)/.ssh/github_signing_ed25519


# Tell git how to sign
git config --global gpg.format ssh

# Establish the key it should use
git config --global user.signingkey /home/$(whoami)/.ssh/github_signing_ed25519


# Default to signing (unless you always commit with -S)
git config --global commit.gpgsign true
