# Node Version Management: nenv
## based on [rbenv](https://github.com/sstephenson/rbenv)

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


### License

(The MIT license)

Copyright (c) 2013 Sam Stephenson Ryuichi Maeno

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
