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

| Target | Base Image Tag | Build Context | Intended Role |
|---|---|---|---|
| Vulnerable comparison target | `php:8.3.35-fpm-alpine` | `docker/vulnerable.Dockerfile` | Negative policy-verification case (Expected to fail) |
| Remediated comparison target | `php:8.3.36-fpm-alpine` | `docker/patched.Dockerfile` | Positive policy-verification case (Expected to pass) |

The vulnerable comparison target is expected to fail the configured PHP 8.3 patch-version policy. The remediated comparison target is expected to pass that specific version check.

These outcomes demonstrate **policy compliance**, not an absolute proof of exploit execution or an assertion that a runtime is completely free of other vulnerabilities.

The pipeline also uses Aqua Security Trivy to inspect container software components and produces structured JSON reports that are aggregated into an HTML audit dashboard.

### What the project demonstrates

- **Preventive security:** Rejecting a container runtime that fails patch-version compliance before deployment.
- **Detective security:** Scanning container base images for known vulnerabilities.
- **Automated verification:** Testing both rejection (negative test) and acceptance (positive test) paths.
- **Security reporting:** Converting raw scanner JSON output into an accessible HTML report.
- **Continuous delivery:** Automatically publishing generated audit dashboards through GitHub Pages.
- **Infrastructure awareness:** Applying PHP configuration controls while recognizing operational trade-offs.

---

## 🚨 Security Context

PHP2Shell Sentinel is designed around the supplied PHP multipart-boundary overflow and potential remote-code-execution threat scenario.

The project identifies the following CVE references as its intended investigation scope:

| Identifier | Project context |
|---|---|
| `CVE-2026-109618` | Supplied vulnerability reference |
| `CVE-2026-109619` | Supplied vulnerability reference |
| CVSS 9.2 | Supplied severity value; verify against authoritative advisories |

**Important verification note:** The identifiers, affected versions, exploitability, severity, and remediation thresholds should be validated against official CVE databases and upstream PHP security advisories before treating them as production baselines.

### Why this matters

A vulnerability-management pipeline distinguishes between:

1. An upstream security advisory.
2. A configured version-compliance rule.
3. A scanner's vulnerability findings.
4. A runtime exploitability assessment.
5. A successful security validation test.

For this project, the deterministic version gate enforces policy compliance. Trivy provides independent vulnerability scanning. Neither alone replaces comprehensive application-level security testing.

---

## 🎯 Project Objectives

1. Build container images representing vulnerable and remediated PHP runtime versions.
2. Query the runtime version directly from the containerized PHP interpreter.
3. Enforce an explicit, deterministic patch-version policy via Bash script automation.
4. Verify that noncompliant runtimes are rejected (negative testing).
5. Verify that compliant runtimes are accepted (positive testing).
6. Scan container images using Aqua Security Trivy.
7. Generate machine-readable vulnerability reports in JSON format.
8. Aggregate findings into an HTML report using Python.
9. Deploy the live audit dashboard to GitHub Pages automatically upon successful CI runs.
10. Document all security controls, assumptions, and failure handling.

---

## ✨ Key Features

### 1. Dual-target container assessment
Compares two PHP-FPM container targets against the same version policy to validate both rejection and acceptance behaviors.

### 2. Deterministic version verification
The policy script queries the containerized PHP interpreter directly:
```bash
php -r 'echo PHP_VERSION;'
