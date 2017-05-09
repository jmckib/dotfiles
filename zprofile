# this file is run only on the initial login (when a terminal tab is opened)
# but not when screen is invoked or a new screen frame is created.
# Basically, if it says "Last login: ..." then this file is run.

#===============
#  MISCELLANEOUS
#===============
# add private keys to the ssh-agent (this will prompt for password)
ssh-add

eval "$(pyenv init -)"
