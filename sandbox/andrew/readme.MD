## Andrew Brown's NCSS-Tech sandbox

Most of the contents of Andrew Brown's sandbox can be found within a **submodule** of `soil-pit`. A submodule is essentially a symbolic link to another project's repository. Here, the sandbox is linked to `sANDREWbox` (a repository on brownag's page). Follow the instructions below to get the submodule contents into your local instance of `soil-pit`.

### Cloning a submodule

To get the contents of a submodule, `git pull` the latest changes then navigate to the directory `sANDREWbox` via the Git command-line or graphical user interface:

```
cd soil-pit\sandbox\andrew\sANDREWbox
```

Then fetch all the data from the submodule and check out the appropriate commit listed in the `soil-pit` superproject:

```
git submodule init
git submodule update
```

Alternately, you can supply the `--recursive` argument to `git clone` to fetch all submodules of a repository when you first create the instance.

```
git clone --recursive https://github.com/ncss-tech/soil-pit.git
```