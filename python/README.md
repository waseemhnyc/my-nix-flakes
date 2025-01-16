# Python 

There are packages like [uv2nix](https://github.com/pyproject-nix/uv2nix) that allow you to install python packages into a nix shell.

However, for projects that are not using nix and have a requirements.txt file, I find it easier to just install my python version and uv with nix. Then use uv to install packages.

On newer projects I use [uv2nix](https://github.com/pyproject-nix/uv2nix).