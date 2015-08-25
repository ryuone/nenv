# Groom your app’s NodeJS / io.js environment with nenv.

nenv is a version manager for Node ([Node.js](https://github.com/joyent/node) /
[io.js](https://github.com/nodejs/node)). It is heavily based on [rbenv](https://github.com/sstephenson/rbenv).

Use nenv to pick a Node.js / io.js version for your application and guarantee
that your development environment matches production. Put nenv to work
with [npm](http://www.npmjs.com/) for painless Node upgrades and
bulletproof deployments.

## Table of Contents

* [How It Works](#how-it-works)
  * [Understanding PATH](#understanding-path)
  * [Understanding Shims](#understanding-shims)
  * [Choosing the Node Version](#choosing-the-node-version)
  * [Locating the Node Installation](#locating-the-node-installation)
* [Installation](#installation)
  * [Basic GitHub Checkout](#basic-github-checkout)
    * [Upgrading](#upgrading)
  * [How nenv hooks into your shell](#how-nenv-hooks-into-your-shell)
  * [Installing Node Versions](#installing-node-versions)
  * [Uninstalling Node Versions](#uninstalling-node-versions)
  * [Uninstalling nenv](#uninstalling-nenv)
* [Command Reference](#command-reference)
  * [nenv local](#nenv-local)
  * [nenv global](#nenv-global)
  * [nenv shell](#nenv-shell)
  * [nenv versions](#nenv-versions)
  * [nenv version](#nenv-version)
  * [nenv rehash](#nenv-rehash)
  * [nenv which](#nenv-which)
  * [nenv whence](#nenv-whence)
* [Environment variables](#environment-variables)
* [Development](#development)

## How It Works

At a high level, nenv intercepts Node commands using shim
executables injected into your `PATH`, determines which Node version
has been specified by your application, and passes your commands along
to the correct Node installation.

### Understanding PATH

When you run a command like `node` or `gulp`, your operating system
searches through a list of directories to find an executable file with
that name. This list of directories lives in an environment variable
called `PATH`, with each directory in the list separated by a colon:

    /usr/local/bin:/usr/bin:/bin

Directories in `PATH` are searched from left to right, so a matching
executable in a directory at the beginning of the list takes
precedence over another one at the end. In this example, the
`/usr/local/bin` directory will be searched first, then `/usr/bin`,
then `/bin`.

### Understanding Shims

nenv works by inserting a directory of _shims_ at the front of your
`PATH`:

    ~/.nenv/shims:/usr/local/bin:/usr/bin:/bin

Through a process called _rehashing_, nenv maintains shims in that
directory to match every Node command across every installed version
of Node—`node`, `npm`, `gulp`  and so on.

Shims are lightweight executables that simply pass your command along
to nenv. So with nenv installed, when you run, say, `gulp`, your
operating system will do the following:

* Search your `PATH` for an executable file named `gulp`
* Find the nenv shim named `gulp` at the beginning of your `PATH`
* Run the shim named `gulp`, which in turn passes the command along to
  nenv

### Choosing the Node Version

When you execute a shim, nenv determines which Node version to use by
reading it from the following sources, in this order:

1. The `NENV_VERSION` environment variable, if specified. You can use
   the [`nenv shell`](#nenv-shell) command to set this environment
   variable in your current shell session.

2. The first `.node-version` file found by searching the directory of the
   script you are executing and each of its parent directories until reaching
   the root of your filesystem.

3. The first `.node-version` file found by searching the current working
   directory and each of its parent directories until reaching the root of your
   filesystem. You can modify the `.node-version` file in the current working
   directory with the [`nenv local`](#nenv-local) command.

4. The global `~/.nenv/version` file. You can modify this file using
   the [`nenv global`](#nenv-global) command. If the global version
   file is not present, nenv assumes you want to use the "system"
   Node—i.e. whatever version would be run if nenv weren't in your
   path.

### Locating the Node Installation

Once nenv has determined which version of Node your application has
specified, it passes the command along to the corresponding Node
installation.

Each Node version is installed into its own directory under
`~/.nenv/versions`. For example, you might have these versions
installed:

* `~/.nenv/versions/3.2.0/`
* `~/.nenv/versions/0.12.7/`

Version names to nenv are simply the names of the directories in
`~/.nenv/versions`.

## Installation

### Basic GitHub Checkout

This will get you going with the latest version of nenv and make it
easy to fork and contribute any changes back upstream.

1. Check out nenv into `~/.nenv`.

    ~~~ sh
    $ git clone https://github.com/ryuone/nenv.git ~/.nenv
    ~~~

2. Add `~/.nenv/bin` to your `$PATH` for access to the `nenv`
   command-line utility.

    ~~~ sh
    $ echo 'export PATH="$HOME/.nenv/bin:$PATH"' >> ~/.bash_profile
    ~~~

    **Ubuntu Desktop note**: Modify your `~/.bashrc` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

3. Add `nenv init` to your shell to enable shims and autocompletion.

    ~~~ sh
    $ echo 'eval "$(nenv init -)"' >> ~/.bash_profile
    ~~~

    _Same as in previous step, use `~/.bashrc` on Ubuntu, or `~/.zshrc` for Zsh._

4. Restart your shell so that PATH changes take effect. (Opening a new
   terminal tab will usually do it.) Now check if nenv was set up:

    ~~~ sh
    $ nenv versions
    #=> "system"
    ~~~

#### Upgrading

If you've installed nenv manually using git, you can upgrade your
installation to the cutting-edge version at any time.

~~~ sh
$ cd ~/.nenv
$ git pull
~~~

To use a specific release of nenv, check out the corresponding tag:

~~~ sh
$ cd ~/.nenv
$ git fetch
$ git checkout v0.0.6
~~~


### How nenv hooks into your shell

Skip this section unless you must know what every line in your shell
profile is doing.

`nenv init` is the only command that crosses the line of loading
extra commands into your shell. Coming from RVM, some of you might be
opposed to this idea. Here's what `nenv init` actually does:

1. Sets up your shims path. This is the only requirement for nenv to
   function properly. You can do this by hand by prepending
   `~/.nenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.nenv/completions/nenv.bash` will set that
   up. There is also a `~/.nenv/completions/nenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this automatically makes sure everything is up to
   date. You can always run `nenv rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows
   nenv and plugins to change variables in your current shell, making
   commands like `nenv shell` possible. The sh dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `nenv` to be a real script rather than a
   shell function, you can safely skip it.

Run `nenv init -` for yourself to see exactly what happens under the
hood.

### Installing Node Versions

~~~ sh
# list all available versions:
$ nenv install -l

# install a Node version:
$ nenv install 3.2.0
~~~

Alternatively to the `install` command, you can download and compile
Node manually as a subdirectory of `~/.nenv/versions/`. An entry in
that directory can also be a symlink to a Node version installed
elsewhere on the filesystem. nenv doesn't care; it will simply treat
any entry in the `versions/` directory as a separate Node version.

### Uninstalling Node Versions

As time goes on, Node versions you install will accumulate in your
`~/.nenv/versions` directory.

To remove old Node versions, simply `rm -rf` the directory of the
version you want to remove. You can find the directory of a particular
Node version with the `nenv prefix` command, e.g. `nenv prefix
3.2.0`.

You can also run the `nenv uninstall` command to
automate the removal process.

### Uninstalling nenv

The simplicity of nenv makes it easy to temporarily disable it, or
uninstall from the system.

1. To **disable** nenv managing your Node versions, simply remove the
  `nenv init` line from your shell startup configuration. This will
  remove nenv shims directory from PATH, and future invocations like
  `node` will execute the system Node version, as before nenv.

  `nenv` will still be accessible on the command line, but your Node
  apps won't be affected by version switching.

2. To completely **uninstall** nenv, perform step (1) and then remove
   its root directory. This will **delete all Node versions** that were
   installed under `` `nenv root`/versions/ `` directory:

        rm -rf `nenv root`

   If you've installed nenv using a package manager, as a final step
   perform the nenv package removal. For instance, for Homebrew:

        brew uninstall nenv

## Command Reference

Like `git`, the `nenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

### nenv local

Sets a local application-specific Node version by writing the version
name to a `.node-version` file in the current directory. This version
overrides the global version, and can be overridden itself by setting
the `NENV_VERSION` environment variable or with the `nenv shell`
command.

    $ nenv local 3.2.0

When run without a version number, `nenv local` reports the currently
configured local version. You can also unset the local version:

    $ nenv local --unset

Previous versions of nenv stored local version specifications in a
file named `.nenv-version`. For backwards compatibility, nenv will
read a local version specified in an `.nenv-version` file, but a
`.node-version` file in the same directory will take precedence.

### nenv global

Sets the global version of Node to be used in all shells by writing
the version name to the `~/.nenv/version` file. This version can be
overridden by an application-specific `.node-version` file, or by
setting the `NENV_VERSION` environment variable.

    $ nenv global 3.2.0

The special version name `system` tells nenv to use the system Node
(detected by searching your `$PATH`).

When run without a version number, `nenv global` reports the
currently configured global version.

### nenv shell

Sets a shell-specific Node version by setting the `NENV_VERSION`
environment variable in your shell. This version overrides
application-specific versions and the global version.

    $ nenv shell 3.2.0

When run without a version number, `nenv shell` reports the current
value of `NENV_VERSION`. You can also unset the shell version:

    $ nenv shell --unset

Note that you'll need nenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`NENV_VERSION` variable yourself:

    $ export NENV_VERSION=3.2.0

### nenv versions

Lists all Node versions known to nenv, and shows an asterisk next to
the currently active version.

    $ nenv versions
      system
      0.12.4
    * 3.2.0 (set by /home/madumlao/.nenv/version)

### nenv version

Displays the currently active Node version, along with information on
how it was set.

    $ nenv version
    3.2.0 (set by /home/madumlao/.nenv/version)

### nenv rehash

Installs shims for all Node executables known to nenv (i.e.,
`~/.nenv/versions/*/bin/*`). Run this command after you install a new
version of Node, or install a gem that provides commands.

    $ nenv rehash

### nenv which

Displays the full path to the executable that nenv will invoke when
you run the given command.

    $ nenv which node
    /home/madumlao/.nenv/versions/3.2.0/bin/node

### nenv whence

Lists all Node versions with the given command installed.

    $ nenv whence gulp
    0.12.4
    3.2.0

## Environment variables

You can affect how nenv operates with the following settings:

| name             | default             | description                                                                               |
|:-----------------|:--------------------|:------------------------------------------------------------------------------------------|
| `NENV_VERSION`   |                     | Specifies the Node version to be used.<br>Also see [`nenv shell`](#nenv-shell)            |
| `NENV_ROOT`      | `~/.nenv`           | Defines the directory under which Node versions and shims reside.<br>Also see `nenv root` |
| `NENV_DEBUG`     |                     | Outputs debug information.<br>Also as: `nenv --debug <subcommand>`                        |
| `NENV_HOOK_PATH` | [_see wiki_][hooks] | Colon-separated list of paths searched for nenv hooks.                                    |
| `NENV_DIR`       | `$PWD`              | Directory to start searching for `.node-version` files.                                   |

## Development

The nenv source code is [hosted on
GitHub](https://github.com/ryuone/nenv). Help us maintain it!

nenv heavily inspired by [rbenv](https://github.com/sstephenson/rbenv). Please refer to rbenv for architecture and inspiration.


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
