#!/bin/bash
set -e

IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
  echo "[-] Error: Target container image name not specified."
  echo "Usage: $0 <image-name>"
  exit 2
fi

echo "======================================================"
echo "[*] INITIATING SECURITY POLICY AUDIT"
echo "[*] Target Asset: $IMAGE_NAME"
echo "======================================================"

PHP_FULL_VER=$(docker run --rm "$IMAGE_NAME" php -r 'echo PHP_VERSION;')
echo "[+] Detected Runtime: PHP $PHP_FULL_VER"

MAJOR=$(echo "$PHP_FULL_VER" | cut -d. -f1)
MINOR=$(echo "$PHP_FULL_VER" | cut -d. -f2)
PATCH=$(echo "$PHP_FULL_VER" | cut -d. -f3 | cut -d- -f1)

IS_VULNERABLE=0

# Patch boundaries: >= 8.2.35, >= 8.3.36, >= 8.4.27, >= 8.5.12
if [ "$MAJOR" -eq 8 ]; then
  if [ "$MINOR" -eq 2 ] && [ "$PATCH" -lt 35 ]; then IS_VULNERABLE=1; fi
  if [ "$MINOR" -eq 3 ] && [ "$PATCH" -lt 36 ]; then IS_VULNERABLE=1; fi
  if [ "$MINOR" -eq 4 ] && [ "$PATCH" -lt 27 ]; then IS_VULNERABLE=1; fi
  if [ "$MINOR" -eq 5 ] && [ "$PATCH" -lt 12 ]; then IS_VULNERABLE=1; fi
fi

if [ "$IS_VULNERABLE" -eq 1 ]; then
  echo ""
  echo "[-] POLICY VIOLATION DETECTED"
  echo "[-] Severity: CRITICAL (CVSS 9.2)"
  echo "[-] Identifiers: CVE-2026-109618, CVE-2026-109619, CERT-In CIAD-2026-0052"
  echo "[-] Condition: PHP $PHP_FULL_VER is below the mandated patch cutoff."
  echo "[-] Action: Pipeline build blocked. Upgrade base image to PHP >= 8.3.36."
  exit 1
else
  echo ""
  echo "[+] POLICY COMPLIANCE CONFIRMED"
  echo "[+] PHP $PHP_FULL_VER meets security baseline requirements."
  exit 0
fi
