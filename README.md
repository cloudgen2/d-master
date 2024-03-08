# heartbeat

## Installation of d-master

You needed to install d-master before any operation, especially for building the docker image file:
```
./d-master self-install 
```

## Build

The following is the build command

```Shell
d-master build
```

If you wanted to build a "test docker image" instead, you can use the -t or --test swtich:
```
d-master -t build
```

## Run The Container

### Create and Run The Container
Create the container
```Shell
d-master run
```

If you wanted to create a "test container" instead, you can use the -t or --test swtich:
```
d-master -p:Alpine-3.16 run
```

### Execution of the shell
```
d-master -p:Alpine-3.16 exec
```

