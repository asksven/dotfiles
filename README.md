# My dotfiles

## Initial setup

1. Clone: `git clone git@github.com:asksven/dotfiles.git ~/dotfiles`
1. Install: `cd dotfiles && ./install.sh`
1. Take care of the sensitive data stored on g-drive

## Add configs from g-drive

Requires insync to be installed and sync to be finished.

1. Check your local .ssh and backup whatever you have there
1. `ln -s /$HOME/<g-drive-dir>/configs/dotssh/$HOSTNAME-ssh ~/.ssh


## Add a config to g-drive

E.g. for .ssh (one directory per machine)

```
cd <g-drive-dir> # e.g. ~/firstname.lastname@gmail.com
cd configs
mkdir dotssh
mv ~/.ssh .
mv .ssh $HOSTNAME-ssh
ln -s $PWD/$HOSTNAME-ssh ~/.ssh
```

