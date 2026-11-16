#!/bin/sh

# Downloads the FLUX.2 [klein] 9B model set into ComfyUI's models directory.
#
# All four files are gated on Hugging Face under the FLUX Non-Commercial
# License. One-time manual prep (cannot be automated):
#   1. Log in to huggingface.co and accept the license on each of:
#        https://huggingface.co/black-forest-labs/FLUX.2-klein-9b-fp8
#        https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9b-fp8
#        https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b
#   2. Create a *read* access token.
#   3. Either `export HF_TOKEN=hf_...` for this shell, or save it once to
#      ~/.cache/huggingface/token (chmod 600). That path is also what
#      ComfyUI's bundled model_downloader node reads.
# The token is only read, never written anywhere by this script, and must
# never be committed to this repo.
#
# Downloads resume if interrupted; already-complete files are skipped.
set -eu

MODELS_DIR="${COMFYUI_MODELS_DIR:-$HOME/comfyui/models}"

if [ -z "${HF_TOKEN:-}" ] && [ -r "$HOME/.cache/huggingface/token" ]; then
  HF_TOKEN=$(tr -d '[:space:]' < "$HOME/.cache/huggingface/token")
fi
if [ -z "${HF_TOKEN:-}" ]; then
  echo "error: no Hugging Face token found." >&2
  echo "       export HF_TOKEN=hf_... or save it to ~/.cache/huggingface/token" >&2
  exit 1
fi

# fetch <models-subdir> <filename> <url>
fetch() {
  dest_dir="$MODELS_DIR/$1"
  dest="$dest_dir/$2"
  mkdir -p "$dest_dir"
  echo "==> $1/$2"

  if [ -s "$dest" ]; then
    # Compare against the final (post-redirect) Content-Length so a finished
    # file is skipped instead of tripping curl's resume-past-end error.
    remote=$(curl --silent --head --location --header "Authorization: Bearer $HF_TOKEN" "$3" \
      | tr -d '\r' | awk 'tolower($1) == "content-length:" { len = $2 } END { print len }')
    local_size=$(stat -c %s "$dest")
    if [ -n "$remote" ] && [ "$remote" = "$local_size" ]; then
      echo "    already complete, skipping"
      return
    fi
  fi

  # --fail turns 401/403 (license not accepted / bad token) and 404 into a
  # hard error instead of silently saving an HTML error page as the model.
  curl --fail --location --continue-at - --progress-bar \
    --header "Authorization: Bearer $HF_TOKEN" \
    --output "$dest" "$3"
}

fetch diffusion_models flux-2-klein-9b-fp8.safetensors \
  https://huggingface.co/black-forest-labs/FLUX.2-klein-9b-fp8/resolve/main/flux-2-klein-9b-fp8.safetensors

fetch diffusion_models flux-2-klein-base-9b-fp8.safetensors \
  https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9b-fp8/resolve/main/flux-2-klein-base-9b-fp8.safetensors

# The upstream repo name really is spelled "encorder".
fetch text_encoders qwen_3_8b_fp8mixed.safetensors \
  https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b_fp8mixed.safetensors

fetch vae flux2-vae.safetensors \
  https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/vae/flux2-vae.safetensors

echo
echo "Done. Restart ComfyUI so it rescans models:  systemctl restart comfyui"
