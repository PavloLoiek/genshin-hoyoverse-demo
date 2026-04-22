#!/bin/bash
set -e

# Upload demo assets to the Omilia Copilot platform in 4 stages.
# Usage: ./upload.sh <base_url> <auth_token>
#   base_url:   Copilot platform API base URL (e.g. https://copilot.example.com)
#   auth_token: Bearer token for the Copilot platform

BASE_URL="${1:-}"
AUTH_TOKEN="${2:-}"

if [ -z "$BASE_URL" ] || [ -z "$AUTH_TOKEN" ]; then
  echo "Usage: $0 <base_url> <auth_token>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
UPLOAD_DIR="$PROJECT_DIR/manual_upload"

upload_folder () {
  local folder="$1"
  if [ ! -d "$folder" ]; then
    echo "  (no folder: $folder — skipping)"
    return
  fi
  shopt -s nullglob
  local found=0
  for f in "$folder"/*; do
    [ -f "$f" ] || continue
    found=1
    echo "  Uploading: $(basename "$f")"
    curl -s -X POST "$BASE_URL/api/v1/knowledge/upload" \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -F "file=@$f" \
      || echo "  !! upload failed for $(basename "$f")"
    echo ""
  done
  if [ "$found" -eq 0 ]; then
    echo "  (no files in $folder)"
  fi
  shopt -u nullglob
}

echo "=== STAGE 1: Upload FAQ ==="
echo "Upload files from manual_upload/1_faq/"
upload_folder "$UPLOAD_DIR/1_faq"
echo ""
echo ">>> SAY: 'The agent now has product knowledge. Ask it anything about rates, hours, programs.'"
echo ">>>       'But try to pay a bill — it can't, because it has no access to backend systems yet.'"
echo ">>> SHOW: Ask FAQ questions (agent answers). Ask to pay a bill (agent says it can't)."
echo ">>> Press Enter when ready for Stage 2..."
read

echo "=== STAGE 2: Upload API Specs ==="
echo "Upload files from manual_upload/2_api_specs/"
upload_folder "$UPLOAD_DIR/2_api_specs"
echo ""
echo ">>> SAY: 'Now the agent has system access. Watch — it pulls the balance correctly.'"
echo ">>>       'But notice it didn't verify the caller's identity before sharing sensitive info.'"
echo ">>>       'That's a compliance violation. It works, but it's doing it wrong.'"
echo ">>> SHOW: Ask for balance (agent gives it WITHOUT verifying identity). Process payment (no confirmation)."
echo ">>> Press Enter when ready for Stage 3..."
read

echo "=== STAGE 3: Upload Policies & SOPs ==="
echo "Upload files from manual_upload/3_policies_and_sops/"
upload_folder "$UPLOAD_DIR/3_policies_and_sops"
echo ""
echo ">>> SAY: 'Now it follows proper procedure — see, it verifies identity before sharing the balance.'"
echo ">>>       'But the conversation feels robotic. Watch what happens when the caller doesn't have their member ID...'"
echo ">>>       'The agent gets stuck. Real human agents handle this differently.'"
echo ">>> SHOW: Standard call (proper procedure). Then call without account number (agent gets stuck)."
echo ">>> Press Enter when ready for Stage 4..."
read

echo "=== STAGE 4: Upload Call Transcripts ==="
echo "Upload files from manual_upload/4_call_transcripts/"
upload_folder "$UPLOAD_DIR/4_call_transcripts"
echo ""
echo ">>> SAY: 'Now watch the same scenario — caller doesn't have their member ID.'"
echo ">>>       'Instead of getting stuck, the agent asks three alternative questions,'"
echo ">>>       'just like a trained human agent would. It learned that from analyzing'"
echo ">>>       'how your best agents handle this situation.'"
echo ">>> SHOW: Same edge case as Stage 3 — now resolved with alternative auth + empathy."
echo ">>> This is the big 'aha' moment!"
