Contributing
===

:zap: Thank you for taking the time to contribute!<br />
Contributing to mkdx is very easy, no matter what you would like to do :)

# Table of Contents

- [Contributing](#contributing)
- [Table of Contents](#table-of-contents)
- [Code of Conduct](#code-of-conduct)
- [Opening an issue](#opening-an-issue)
- [Requesting a feature](#requesting-a-feature)
- [Sending pull requests](#sending-pull-requests)
- [Testing changes](#testing-changes)

# Code of Conduct

Please refer to [Contributor Covenant Code of Conduct](https://github.com/SidOfc/mkdx/blob/master/CODE_OF_CONDUCT.md) located inside this repository.

# Opening an issue

When you've found something that doesn't work, visit the [issues](https://github.com/SidOfc/mkdx/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Abug) page to check wether no such issue already exists.
If your issue doesn't exist, open a new [issue](issues/new).
There is already some template information there but you can (and probably should) add more context / information as required.

Please **do not discard** the template when filing a bug. Fill in the checkboxes by inserting an `x` to what applies to you.
e.g. for the _OS type_, if you are using a _Unix_ based system, mark the _Unix_ checkbox like so:

```markdown
- [x] Unix
```

# Requesting a feature

Think you've got a good idea for mkdx? Visit the [issues](https://github.com/SidOfc/mkdx/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Afeature-request) page
and check to see if someone didn't already beat you to it :)
If your feature isn't requested yet, open a new [issue](issues/new).

The template is mostly useful for bugs since it requires some information about the issuer's computer and a reproducible example.
Therefore, you are free to clear out the template and just start describing your feature.
It is very helpful to include a graphical example, with that I mean that you can include a "before" snippet
and an "after" snippet of what you wish to accomplish.

# Sending pull requests

- [Fork this repository](https://help.github.com/articles/fork-a-repo/).
- Apply your patch, commit and push back to your fork.
- Open a new GitHub pull request with your patch.
- Make sure that the description includes the problem scenario and the solution, include any issue numbers.
- That's it, send the PR!

# Testing changes

It can happen that an issue cannot be reproduced on my machine in which case I might ask if you are willing to test
a specific branch and confirm wether the issue is fixed. There are some simple steps you can follow to go through this process easily.
I promise it will not mess up your plugin manager in any way, you'll basically checkout the branch, test the feature and revert to master
so that the plugin can be updated normally. Or well, you could choose to stay on the feature branch if you choose :)

So imagine there is an issue with checkboxes and a remote branch `bug/checkbox-not-toggled-correctly`.
You would first have to navigate to the installation directory of `mkdx`, this directory is typically located inside `~/.vim` and called
either `bundle` for Vundle users or `plugged` for vim-plug users for instance. Within these folders, you will find all your installed plugins.
The folder name you are looking for will be `mkdx` so in the end, your path will look something like this (with vim-plug): `~/.vim/plugged/mkdx`.

    $ cd ~/.vim/plugged/mkdx
    $ git pull origin bug/checkbox-not-toggled-correctly
    $ git checkout bug/checkbox-not-toggled-correctly

Now, when you open Vim, you can test to see if the functionality works correctly. Once confirmed you can revert back to master
using the following commands:

    $ cd ~/.vim/plugged/mkdx
    $ git checkout master
