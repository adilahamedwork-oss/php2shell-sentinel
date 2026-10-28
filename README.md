# PHP2Shell Sentinel — Verified DevSecOps Defense Pipeline

[![DevSecOps Security Gate](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions/workflows/security-gate.yml/badge.svg)](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions)
[![Live Security Audit Dashboard](https://img.shields.io/badge/Live_Audit-Dashboard-blue?style=flat&logo=github)](https://adilahamedwork-oss.github.io/php2shell-sentinel/)

An automated container vulnerability scanning, deterministic policy enforcement, and self-healing DevSecOps pipeline targeting the PHP2Shell remote code execution vulnerabilities (CVE-2026-109618 & CVE-2026-109619, CVSS 9.2).

---

## Architecture Flow

- Step 1: Code is pushed to GitHub.
- Step 2: GitHub Actions builds two container images (Vulnerable `php:8.3.35` and Patched `php:8.3.36`).
- Step 3: Custom semver policy gate (`verify_policy.sh`) evaluates both runtimes.
- Step 4: Vulnerable image is blocked with exit code 1; patched image is approved with exit code 0.
- Step 5: Aquasec Trivy scans the images and Python generates the audit dashboard.
- Step 6: GitHub Pages automatically deploys the live security dashboard.

---

## Core DevSecOps Controls

1. **Deterministic Semver Policy Gate (`scripts/verify_policy.sh`)**
   - Directly executes the container runtime to extract `PHP_VERSION`.
   - Enforces strict patch cutoffs (`>= 8.2.35`, `>= 8.3.36`, `>= 8.4.27`, `>= 8.5.12`) independently of upstream scanner database sync delays.

2. **Dual-Matrix CI Verification**
   - Negative Control: Confirms unpatched runtimes break the build.
   - Positive Control: Confirms compliant runtimes pass admission.

3. **Defense-in-Depth Interim Mitigations**
   - Directives in `docker/mitigations/php2shell-mitigation.ini` protect systems during patch triage windows:
     - `memory_limit = -1`
     - `post_max_size = 8M`
     - `upload_max_filesize = 7M`
     - `session.upload_progress.enabled = 0`

4. **Automated Evidence Compilation**
   - Scans images with Trivy, extracts JSON metrics, and compiles an audit dashboard.

---

## Local Lab Reproduction

Clone and run the policy gate locally:

```bash
git clone https://github.com/adilahamedwork-oss/php2shell-sentinel.git
cd php2shell-sentinel

# Build container targets
docker build -t php2shell:vuln -f docker/vulnerable.Dockerfile .
docker build -t php2shell:patched -f docker/patched.Dockerfile .

# Verify policy enforcement
./scripts/verify_policy.sh php2shell:vuln
./scripts/verify_policy.sh php2shell:patched
