# JvlongGSIs

> Just a simple tool to compare ErfanGSI's GSI and Official Firmware. 

## How to use?

### First, clone this repo:

```bash
git clone https://github.com/together08/JvlongGSIs.git --depth=1
cd JvlongGSIs
```

### Then, setting up requirements:

```bash
bash setup.sh
```

### Finally, make the GSI:

> May you need to enter sudo password during making.

```bash
# For local ROM, use this command:
./make.sh <Path to firmware> <ROM NAME>

# For URL(Download Link), use this command:
./urlmake.sh <URL of firmware> <ROM NAME>
```