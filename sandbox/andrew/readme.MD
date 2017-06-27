#Andrew Brown's NCSS-Tech sandbox

Most of the contents of Andrew Brown's sandbox can be found within a **submodule** of the soil-pit repository. A submodule is essentially a symbolic link to another project's repository. Here, the sandbox is linked to `sANDREWbox` (a repository on brownag's page). Follow the instructions below to get the submodule contents into your local instance of `soil-pit`.

### Cloning a submodule

To get the contents of a submodule, first clone/pull latest changes the `soil-pit` repository: 

```
git clone https://github.com/ncss-tech/soil-pit.git
```

Then navigate to the directory `sANDREWbox` via Git command-line or graphical user interface:

```
cd sandbox\andrew\sANDREWbox
```

Then fetch all the data from the submodule and check out the appropriate commit listed in the `soil-pit` superproject:

```
git submodule init
git submodule update
```