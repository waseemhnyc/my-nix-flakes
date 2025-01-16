# Flakes

My common nix flakes.

## How to use

Assuming you have the following installed:
- nix
- direnv

Create a new directory and create a file name `.envrc`. The file should contain the following:

```bash
use flake .
```

Or run:
```bash
echo "use flake ." > .envrc
```

In the new directory run `direnv allow`. This lets direnv know that the directory should be used as a nix shell.

Copy one of the `flake.nix` files as a starting point to your project.

Enter back into your shell. Your shell should have acknwoledge the new flake and you should be able to use any of the packages found in that flake.nix.

## Example
Say you have python installed on your system.

Outside of your directory with your flake:

```bash
$ which python
/usr/local/bin/python
```

Inside your directory with your flake:

```bash
$ which python
/nix/store/{some-hash}/bin/python
```
