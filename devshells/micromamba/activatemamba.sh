THIS_SCRIPTS_PARENT="$(dirname ${BASH_SOURCE[0]})"

export MAMBA_ROOT_PREFIX="$THIS_SCRIPTS_PARENT/.micromamba"
eval "$($THIS_SCRIPTS_PARENT/.micromamba/micromamba shell hook -s bash)"
micromamba install -f ./environment.yml
