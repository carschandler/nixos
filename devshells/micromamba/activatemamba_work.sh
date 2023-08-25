THIS_SCRIPTS_PARENT="$(dirname ${BASH_SOURCE[0]})"

# Select nvidia graphics card for mesa/opengl on Arch WSL
export MESA_D3D12_DEFAULT_ADAPTER_NAME="nvidia"

export MAMBA_ROOT_PREFIX="$THIS_SCRIPTS_PARENT/.micromamba"
eval "$($THIS_SCRIPTS_PARENT/.micromamba/micromamba shell hook -s bash)"
micromamba install -f ./environment.yml
