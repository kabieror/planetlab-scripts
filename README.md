# PlanetLab Scripts
These scripts make it easy to deploy and run a distributed Emerald program on many PlanetLab nodes.
Here is what you have to do to start using them:

## 1. Personalise scripts
Edit the file `config.sh` and change the variable `wd` to a personal working dir under `/tmp`.
The directory you specify here will be used to put all needed data in on the PlanetLab nodes.
For example:
```
wd=/tmp/yourname
```

## 2. Add Main Program
Copy or link the program you want to run on the PlanetLab nodes to `node-data/main.x`.
For example:
```
ln -s ../uni/distobj/kilroy.x ./node-data/main.x
```

## 3. Specify nodes
Edit the file `nodes.txt` and insert the nodes, on which your program is to be executed. Note the following:
- The first node in the file will be the one, on which the Emerald program is launched. It will be started, when all other nodes are online.
- The second node in the file will be the first one to start up. All other nodes will connect to it.

## 4. Use the scripts

### install.sh: Prepare all the nodes
Now you are ready to install your program on the nodes. Note that the user you use to run the script needs to have already SSH access to the nodes specified in nodes.txt.
```
install.sh
```

### start.sh: Launch Emerald on all the nodes
```
start.sh
```
This will start all nodes and run the Emerald program on the last one to start up (the first one in nodes.txt). Note that the emerald VMs will continue running after the program finished. But if you run `start.sh` for the next time, the previously started VMs will be killed.

### update.sh: Update Emerald program on all the nodes
If you have made changes to your program, you have to update the file on the nodes.
```
update.sh
```

### stop.sh: Stop Emerald on all the nodes
If you want to stop all running Emerald VMs, you can do so by executing
```
stop.sh
```

### clean.sh: Clean all data on all the nodes
You can delete all data on all nodes you were using by executing
```
clean.sh
```
