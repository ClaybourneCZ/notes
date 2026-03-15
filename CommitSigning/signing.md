# Setup commit signing with SSH key

The SSH key pair generation and setup for platform like GitLab predeceses this setup.

# Optional

>`git config --local user.name "Name surname"`
>`git config --local user.email "school-login@school-mail.com"`

# Signing setup

1st command sets up the format to use `SSH`, 2nd command provides corresponding public key, 3rd command sets up automatization so there is no need for adding `-S` to each commit

>`git config --local gpg.format ssh`
> `git config --local user.signingkey ~/.ssh/id_skolni_klic.pub`
> `git config --local commit.gpgsign true`
