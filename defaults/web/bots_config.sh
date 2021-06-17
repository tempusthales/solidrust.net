apt-get install aptitude
curl https://pyenv.run | bash
aptitude install libreadline-dev libssl-dev libbz2-dev libsqlite3-dev


### add to .bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
###

# logout and login
pyenv install 3.9.5  # or pyenv install $(cat .pyenv)
echo "3.9.5" > solidrust.net/bots/.python-version
cd solidrust.net/bots
python --version
python -m pip install --upgrade pip

pip install -U discord.py

