# 🛡️ PHP2Shell Sentinel
### Automated DevSecOps Vulnerability Verification & Runtime Security Audit

[![Security Gate](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions/workflows/security-gate.yml/badge.svg)](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions/workflows/security-gate.yml)
[![Live Audit Dashboard](https://img.shields.io/badge/Live-Audit%20Dashboard-2ea44f?logo=githubpages&logoColor=white)](https://adilahamedwork-oss.github.io/php2shell-sentinel/)
[![CVSS](https://img.shields.io/badge/CVSS-9.2-critical)](https://nvd.nist.gov/)
[![Security](https://img.shields.io/badge/Focus-DevSecOps-blue?logo=securityscorecard&logoColor=white)](https://github.com/adilahamedwork-oss/php2shell-sentinel)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Reports-Python-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![GitHub Actions](https://img.shields.io/badge/CI-CD-2088FF?logo=githubactions&logoColor=white)](https://github.com/features/actions)

**PHP2Shell Sentinel** is a security-focused DevSecOps lab that demonstrates how containerized PHP runtimes can be assessed, evaluated against an explicit patch-version policy, scanned for known vulnerabilities, and presented through an automatically generated security dashboard.

The project combines container builds, deterministic policy enforcement, negative and positive verification cases, Software Composition Analysis (SCA), automated report aggregation, and GitHub Pages publishing into one repeatable security workflow.

> **Project objective:** Demonstrate how security checks can become enforceable CI/CD controls instead of remaining manual recommendations in a vulnerability report.

**Live dashboard:** https://adilahamedwork-oss.github.io/php2shell-sentinel/

**Repository:** https://github.com/adilahamedwork-oss/php2shell-sentinel

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Security Context](#-security-context)
- [Project Objectives](#-project-objectives)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [Threat Model](#-threat-model)
- [Security Policy](#-security-policy)
- [Policy Verification Logic](#-policy-verification-logic)
- [CI/CD Security Pipeline](#-cicd-security-pipeline)
- [Container Security Strategy](#-container-security-strategy)
- [Interim Runtime Mitigations](#-interim-runtime-mitigations)
- [Software Composition Analysis](#-software-composition-analysis)
- [Automated Reporting and Dashboard](#-automated-reporting-and-dashboard)
- [Repository Structure](#-repository-structure)
- [Prerequisites](#-prerequisites)
- [Local Setup and Reproduction](#-local-setup-and-reproduction)
- [Expected Verification Results](#-expected-verification-results)
- [Security Controls](#-security-controls)
- [Failure Handling](#-failure-handling)
- [Limitations](#-limitations)
- [Future Improvements](#-future-improvements)
- [Learning Outcomes](#-learning-outcomes)
- [References](#-references)
- [Author](#-author)
- [Disclaimer](#-disclaimer)

---

## 🔍 Overview

Modern application security requires more than identifying a vulnerable dependency. Engineering teams need repeatable mechanisms to evaluate software versions, reject policy violations, produce machine-readable evidence, and communicate security findings to developers and stakeholders.

PHP2Shell Sentinel explores that process through a controlled PHP container assessment.

The lab uses two PHP-FPM container targets:

| Target | Container image | Build context | Intended role |
|---|---|---|---|
| Vulnerable comparison target | `php:8.3.35-fpm-alpine` | `docker/vulnerable.Dockerfile` | Negative policy-verification case |
| Remediated comparison target | `php:8.3.36-fpm-alpine` | `docker/patched.Dockerfile` | Positive policy-verification case |

The vulnerable comparison target is expected to fail the configured PHP 8.3 patch-version policy. The remediated comparison target is expected to pass that specific version check.

These outcomes demonstrate **policy compliance**, not a complete proof that a particular exploit succeeds or that a system is free of vulnerabilities.

The pipeline also uses Trivy to inspect container software components and produces reports that can be aggregated into an HTML audit dashboard.

### What the project demonstrates

- **Preventive security:** Rejecting a runtime that does not meet the configured patch policy.
- **Detective security:** Scanning container images for known vulnerabilities.
- **Automated verification:** Testing both rejection and acceptance paths.
- **Security reporting:** Converting scanner output into an accessible HTML report.
- **Continuous delivery:** Publishing generated audit information through GitHub Pages.
- **Infrastructure awareness:** Applying PHP configuration controls while recognizing their operational trade-offs.

---

## 🚨 Security Context

PHP2Shell Sentinel is designed around the supplied PHP multipart-boundary overflow and potential remote-code-execution threat scenario.

The project identifies the following CVE references as its intended investigation scope:

| Identifier | Project context |
|---|---|
| `CVE-2026-109618` | Supplied vulnerability reference |
| `CVE-2026-109619` | Supplied vulnerability reference |
| CVSS 9.2 | Supplied severity value; verify against the authoritative advisory |

**Important verification note:** The identifiers, affected versions, exploitability, severity, and remediation thresholds must be validated against the official CVE records and the relevant PHP security advisory before being treated as confirmed vulnerability intelligence. This README does not independently establish those facts.

### Why this matters

A vulnerability-management pipeline should distinguish between:

1. An upstream security advisory.
2. A configured version-compliance rule.
3. A scanner's vulnerability findings.
4. A runtime exploitability assessment.
5. A successful security validation test.

These are related, but they are not interchangeable.

For this project, the deterministic version gate is an explicit policy control. Trivy provides a separate source of vulnerability findings. Neither alone proves that an application is exploitable or completely secure.

---

## 🎯 Project Objectives

PHP2Shell Sentinel aims to demonstrate a practical security workflow that can be reproduced by developers and reviewed by security engineers.

1. Build container images representing vulnerable and remediated PHP runtime versions.
2. Retrieve the runtime version directly from the PHP interpreter.
3. Enforce an explicit, deterministic patch-version policy.
4. Verify that a noncompliant runtime is rejected.
5. Verify that a compliant runtime is accepted.
6. Scan container images using Aqua Security Trivy.
7. Generate machine-readable vulnerability reports.
8. Aggregate findings into an HTML report using Python.
9. Publish the audit dashboard using GitHub Pages.
10. Document the security controls, assumptions, and limitations of the lab.

---

## ✨ Key Features

### 1. Dual-target container assessment

The pipeline compares two PHP-FPM image tags against the same configured version policy.

This creates a repeatable test environment for demonstrating how patch-version requirements can be enforced.

### 2. Deterministic version verification

The policy script retrieves the actual PHP runtime version using:

```bash
php -r 'echo PHP_VERSION;'
The result is evaluated against the configured minimum version for its PHP release branch.
3. Negative and positive test cases
The pipeline validates both sides of the decision:
 Negative case: A runtime below the required patch threshold must exit with status code ⁠1⁠.
 Positive case: A runtime meeting the configured threshold must exit with status code ⁠0⁠.
4. Automated container scanning
Trivy scans the container targets and exports JSON findings for subsequent processing.
5. Python report aggregation
A Python script consolidates available scan results into an HTML security report.
6. Live audit dashboard
GitHub Pages serves the generated report so that reviewers can inspect the project's security assessment without running the pipeline locally.
7. Reproducible engineering workflow
The project uses version-controlled scripts, declarative configuration, container images, and CI automation to reduce reliance on undocumented manual steps.
🏗️ System Architecture
The system is organized around a GitHub Actions workflow that coordinates container builds, policy enforcement, vulnerability scanning, report generation, and deployment.
Architecture diagram
DEVELOPER / CONTRIBUTOR
                            |
                            v
                  Git Push / Pull Request
                            |
                            v
                 +----------------------+
                 |   GitHub Actions CI  |
                 | (security-gate.yml)  |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 |  Build Matrix        |
                 |----------------------|
                 | Vulnerable PHP       |
                 | docker/vulnerable.*  |
                 |                      |
                 | Remediated PHP       |
                 | docker/patched.*     |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 | Runtime Verification |
                 | PHP_VERSION          |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 | Policy Gate          |
                 | scripts/verify_policy|
                 +----------------------+
                            |
                 +----------+----------+
                 |                     |
                 v                     v
          Noncompliant             Compliant
          Exit Code 1              Exit Code 0
          Admission Blocked        Verification Pass
                 |                     |
                 +----------+----------+
                            |
                            v
                 +----------------------+
                 | Trivy Image Scan    |
                 | SCA / Vulnerability  |
                 | JSON Reports         |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 | Python Aggregation  |
                 | generate_report.py  |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 | Generated HTML      |
                 | Audit Dashboard     |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 | GitHub Pages        |
                 | Live Security View  |
                 +----------------------+
Interpretation: A successful policy check means that the runtime meets the configured version requirement. The vulnerability scan and resulting report provide additional security evidence. Production deployment approval should depend on the required checks and their actual results, rather than on report generation alone.
### Core components

| Component | Responsibility |
|---|---|
| GitHub Actions | Orchestrates CI execution via `.github/workflows/security-gate.yml` |
| Docker | Provides isolated containerized PHP environments |
| PHP interpreter | Supplies the actual runtime version |
| `scripts/verify_policy.sh` | Enforces the configured patch-version policy |
| Trivy | Detects known vulnerabilities in scanned software components |
| `scripts/generate_report.py` | Aggregates scan output into an HTML report |
| GitHub Pages | Hosts the generated dashboard |

---

## 🧩 Threat Model

The following threat model describes the risks this lab is designed to explore. It is not a claim that every threat has been experimentally reproduced.

| Threat | Potential impact | Detection or control | Residual risk |
|---|---|---|---|
| Outdated PHP runtime | Exposure to known security flaws | Runtime version policy | Version checks do not establish full exploitability |
| Vulnerable container dependencies | Known CVEs in OS packages or application components | Trivy image scanning | Scanner databases and coverage can be incomplete |
| Noncompliant runtime entering a build | Vulnerable software may reach a deployment environment | Failing policy gate | Only effective when required by downstream deployment controls |
| Incorrect version comparison | False acceptance or rejection | Deterministic semantic version parsing and test cases | Parser defects or incorrect thresholds remain possible |
| Oversized multipart requests | Excessive memory, storage, or processing consumption | Request-size and resource limits | Limits must be configured and tested at multiple layers |
| Malicious multipart input | Potential parser exploitation if a relevant flaw is present | Patched runtime, regression testing, layered request controls | Configuration limits are not a substitute for a security fix |
| Incorrect scanner output handling | Findings may be missed or misrepresented | JSON validation and report-generation error handling | Invalid schemas or unsupported formats can still cause failures |
| Unauthorized workflow changes | Security checks could be bypassed | Branch protection and workflow permissions | Repository administration and credential compromise remain risks |
| Compromised build dependency | Malicious code may execute during CI | Trusted actions, image provenance, dependency pinning | Supply-chain risk cannot be eliminated by version checks alone |
| Public report exposure | Sensitive environment details could be disclosed | Report sanitization and publication review | Public dashboards require careful data handling |

### Security assumptions

- The CI runner is trusted to execute the configured workflow.
- The PHP runtime reported by the interpreter corresponds to the container being evaluated.
- The patch thresholds are sourced from a verified security policy.
- The scanner has access to a sufficiently current vulnerability database.
- Published reports contain no secrets, credentials, or sensitive environment information.
- The policy gate is required for any deployment path it is intended to protect.

---

## 🔐 Security Policy

The policy gate compares the detected PHP runtime version against the configured minimum version for its release branch.

The supplied policy thresholds are:

| PHP branch | Minimum permitted version |
|---|---|
| PHP 8.2 | `8.2.35` |
| PHP 8.3 | `8.3.36` |
| PHP 8.4 | `8.4.27` |
| PHP 8.5 | `8.5.12` |

**Policy provenance:** These values are project-configured thresholds supplied for this lab. Confirm them against the applicable official PHP security advisory before using them as production compliance requirements.

A minimum-version rule should be maintained as an explicit, reviewed policy rather than assumed to remain correct indefinitely.

### Policy decision model

```text
              Detected PHP Runtime
                       |
                       v
             Parse Semantic Version
                       |
                       v
           Identify PHP Release Branch
                       |
                       v
           Load Approved Patch Threshold
                       |
                       v
            Compare Runtime and Policy
                       |
              +--------+--------+
              |                 |
              v                 v
       Version Too Old      Version Meets
              |             Threshold
              v                 v
        EXIT CODE 1         EXIT CODE 0
        Reject Target       Pass Gate

Important distinction
A runtime can meet a minimum version threshold and still have other vulnerabilities. Conversely, a scanner may report a finding that requires additional exploitability or configuration analysis.
For production use, combine version enforcement with vulnerability scanning, supported-runtime requirements, regression tests, and deployment controls.
🧪 Policy Verification Logic
The script ⁠scripts/verify_policy.sh⁠ is the central policy-enforcement component.
It should:
1. Obtain the PHP version from the runtime being evaluated.
2. Validate that the returned value is a valid semantic version.
3. Identify the appropriate PHP release-branch threshold.
4. Compare the version numerically by major, minor, and patch components.
5. Return exit code ⁠0⁠ if the runtime complies.
6. Return exit code ⁠1⁠ if the runtime violates the policy.
7. Fail closed if the version cannot be determined or the release branch is unsupported.

### Expected behavior

| Test case | Example runtime | Expected result |
|---|---|---|
| Negative verification | `8.3.35` | Exit `1` |
| Positive verification | `8.3.36` | Exit `0` |
| Below threshold | Any supported branch below its minimum | Exit `1` |
| At threshold | Exactly the configured minimum | Exit `0` |
| Above threshold | A newer patch version on a supported branch | Exit `0` |
| Invalid version | Malformed version output | Fail closed |
| Unsupported branch | No configured policy | Fail closed |

The negative case is an expected security-control rejection. It should not be treated as an infrastructure failure when the test harness explicitly expects the rejection.

---

## ⚙️ CI/CD Security Pipeline

GitHub Actions coordinates the project's automated security workflow.

### Trigger conditions

The workflow is configured to run on:

- Push events to `main`.
- Pull request events targeting `main`.
- Manual execution via `workflow_dispatch`.

### Pipeline stages

#### Stage 1 — Checkout
The workflow retrieves repository source code and audit scripts via `actions/checkout@v4`.

#### Stage 2 — Build the comparison targets
The pipeline builds the container targets using Docker:
- Vulnerable comparison target: `docker/vulnerable.Dockerfile`
- Remediated comparison target: `docker/patched.Dockerfile`

#### Stage 3 — Execute the policy gate
The policy script evaluates the runtime version within the target environment:
- **Negative Test:** Rejects noncompliant image (`php2shell:vuln`).
- **Positive Test:** Admits compliant image (`php2shell:patched`).

#### Stage 4 — Scan container images
Trivy evaluates both images and exports structured JSON findings (`trivy-vuln-report.json` and `trivy-patched-report.json`).

#### Stage 5 — Aggregate findings
The Python report generator (`scripts/generate_report.py`) parses JSON outputs and builds `public/index.html`.

#### Stage 6 — Publish the dashboard
On push events to `main`, the static dashboard artifact is deployed securely to GitHub Pages.

---

## 🐳 Container Security Strategy

Container images provide a consistent environment for runtime verification and vulnerability assessment.

### Comparison targets

- **Vulnerable target:** `docker/vulnerable.Dockerfile` (PHP 8.3.35-fpm-alpine baseline)
- **Remediated target:** `docker/patched.Dockerfile` (PHP 8.3.36-fpm-alpine baseline)

### Container security considerations

- Prefer currently supported PHP releases.
- Use verified upstream image tags and inspect their resolved digests.
- Rebuild images regularly to receive current operating-system packages.
- Scan the final image rather than only scanning source files.
- Avoid embedding secrets in Dockerfiles or image layers.
- Run application containers as non-root where supported.
- Set resource boundaries at the container or orchestration layer.

---

## 👨‍💻 Author

**Adil ahamed B**  
Aspiring Cloud Security & DevSecOps Engineer  
- **GitHub:** [adilahamedwork-oss](https://github.com/adilahamedwork-oss)  
- **Live Audit Dashboard:** [php2shell-sentinel](https://adilahamedwork-oss.github.io/php2shell-sentinel/)  
- **Portfolio:** [adil-ahamed-b.vercel.app](https://adil-ahamed-b.vercel.app/)

---

<p align="center">
  <strong>PHP2Shell Sentinel</strong><br>
  <em>Detect. Verify. Enforce. Report.</em>
</p>
