# Node Version Management: nenv

I will write this later.

e.g.)
        $ cd
        $ git clone git://github.com/ryuone/nenv.git .nenv
        $ echo 'export PATH="$HOME/.nenv/bin:$PATH"' >> ~/.zprofile
        $ echo 'eval "$(nenv init -)"' >> ~/.zprofile
          or add to ~/.zshrc
          also ~/.bash_profile

        $ nenv install 0.6.4
        $ nenv install 0.6.3
        $ nenv global 0.6.4
        $ nenv versions
          0.6.3
        * 0.6.4 (set by /home/ryuone/.nenv/version)
        $ nenv local 0.6.3
