**To work with the test case, you need to make changes to the following files:**
```
credentials.auto.tfvars
networks.auto.tfvars
```

**You also need to install Yandex cli, enter your credentials by typing command:**
```
yc init
```
**And generate a temporary access key (Can be done with a script create_yandex_key.sh)**
```
./create_yandex_key.sh
```

**To view your subnets through the console, you can use the command**
```
yc vpc subnets list
```
**You can also call it with a script in this directory**
```
./example_show_current_subnets.sh
```

