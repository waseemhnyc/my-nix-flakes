# Flakes
My most common nix flakes

Assuming you have installed:
- nix
- direnv

Create a new directory and create a file name `.envrc` that direnv with the following content:

```bash
use flake .
```

In the new directory run `direnv allow` to allow the directory to be used as a nix shell.

Copy one of the flake.nix files as a starting point to your project.

Enter back into your shell. Your shell should have acknwoledge the new flake and you should be able to use any of the packages found in that flake.nix file.

Eg:
Say you have python installed on your system.

Outside of your flake directory:

```bash
$ which python
/usr/local/bin/python
```

Inside your flake directory:

```bash
$ which python
/nix/store/{some-hash}/bin/python
```
