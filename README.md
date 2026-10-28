
# 🛡️ PHP2Shell Sentinel
### Automated DevSecOps Vulnerability Verification & Runtime Security Audit

[![Build](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions/workflows/ci.yml/badge.svg)](https://github.com/adilahamedwork-oss/php2shell-sentinel/actions)
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

| Target | Container image | Intended role |
|---|---|---|
| Vulnerable comparison target | `php:8.3.35-fpm-alpine` | Negative policy-verification case |
| Remediated comparison target | `php:8.3.36-fpm-alpine` | Positive policy-verification case |

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
```

The result is evaluated against the configured minimum version for its PHP release branch.

### 3. Negative and positive test cases

The pipeline validates both sides of the decision:

- **Negative case:** A runtime below the required patch threshold must exit with status code `1`.
- **Positive case:** A runtime meeting the configured threshold must exit with status code `0`.

### 4. Automated container scanning

Trivy scans the container targets and exports JSON findings for subsequent processing.

### 5. Python report aggregation

A Python script consolidates available scan results into an HTML security report.

### 6. Live audit dashboard

GitHub Pages serves the generated report so that reviewers can inspect the project's security assessment without running the pipeline locally.

### 7. Reproducible engineering workflow

The project uses version-controlled scripts, declarative configuration, container images, and CI automation to reduce reliance on undocumented manual steps.

---

## 🏗️ System Architecture

The system is organized around a GitHub Actions workflow that coordinates container builds, policy enforcement, vulnerability scanning, report generation, and deployment.

### Architecture diagram

```text
                   DEVELOPER / CONTRIBUTOR
                            |
                            v
                  Git Push / Pull Request
                            |
                            v
                 +----------------------+
                 |   GitHub Actions CI  |
                 +----------------------+
                            |
                            v
                 +----------------------+
                 |  Build Matrix        |
                 |----------------------|
                 | Vulnerable PHP       |
                 | php:8.3.35-fpm-alpine|
                 |                      |
                 | Remediated PHP       |
                 | php:8.3.36-fpm-alpine|
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
```

**Interpretation:** A successful policy check means that the runtime meets the configured version requirement. The vulnerability scan and resulting report provide additional security evidence. Production deployment approval should depend on the required checks and their actual results, rather than on report generation alone.

### Core components

| Component | Responsibility |
|---|---|
| GitHub Actions | Orchestrates CI execution |
| Docker | Provides isolated containerized PHP environments |
| PHP interpreter | Supplies the actual runtime version |
| `verify_policy.sh` | Enforces the configured patch-version policy |
| Trivy | Detects known vulnerabilities in scanned software components |
| `generate_report.py` | Aggregates scan output into an HTML report |
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
```

### Important distinction

A runtime can meet a minimum version threshold and still have other vulnerabilities. Conversely, a scanner may report a finding that requires additional exploitability or configuration analysis.

For production use, combine version enforcement with vulnerability scanning, supported-runtime requirements, regression tests, and deployment controls.

---

## 🧪 Policy Verification Logic

The script `scripts/verify_policy.sh` is the central policy-enforcement component.

It should:

1. Obtain the PHP version from the runtime being evaluated.
2. Validate that the returned value is a valid semantic version.
3. Identify the appropriate PHP release-branch threshold.
4. Compare the version numerically by major, minor, and patch components.
5. Return exit code `0` if the runtime complies.
6. Return exit code `1` if the runtime violates the policy.
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

### Why semantic version comparison matters

String comparisons can produce incorrect results when version components have different numbers of digits.

A deterministic implementation should compare numeric components or use a well-tested semantic-version parser. It should not rely on a naive alphabetical comparison.

---

## ⚙️ CI/CD Security Pipeline

GitHub Actions coordinates the project's automated security workflow.

### Trigger conditions

The workflow is intended to run on:

- Push events.
- Pull request events.

The actual trigger configuration is defined in the repository's workflow YAML.

### Pipeline stages

#### Stage 1 — Checkout

The workflow retrieves the repository source code and scripts needed for the assessment.

#### Stage 2 — Build the comparison targets

The pipeline builds or retrieves the configured PHP container targets:

- Vulnerable comparison target: `php:8.3.35-fpm-alpine`
- Remediated comparison target: `php:8.3.36-fpm-alpine`

The workflow should use explicit image references and record the image identity used for each scan.

#### Stage 3 — Execute the policy gate

The policy script evaluates the runtime version within the target environment.

The negative and positive cases verify that the policy rejects a noncompliant runtime and accepts a compliant one.

#### Stage 4 — Scan container images

Trivy evaluates the configured images and writes JSON reports.

Scanner execution should preserve both the report and the scanner's exit status.

#### Stage 5 — Aggregate findings

The Python report generator consumes the available scan results and produces the HTML audit output.

#### Stage 6 — Publish the dashboard

The generated dashboard is published through GitHub Pages using the repository's configured deployment workflow.

### CI/CD design principles

- Use explicit and reviewable security thresholds.
- Preserve scanner exit codes and distinguish policy failures from execution failures.
- Keep build, scan, report, and deployment responsibilities clear.
- Do not publish reports containing secrets.
- Restrict GitHub Actions permissions to the minimum necessary.
- Pin third-party actions to reviewed commit SHAs for stronger supply-chain security.
- Require security checks before production deployment.
- Retain machine-readable evidence for debugging and auditability.

---

## 🐳 Container Security Strategy

Container images provide a consistent environment for runtime verification and vulnerability assessment.

### Vulnerable comparison target

```text
php:8.3.35-fpm-alpine
```

This image is used as the negative policy-test target under the supplied PHP 8.3 minimum version rule.

### Remediated comparison target

```text
php:8.3.36-fpm-alpine
```

This image is used as the positive policy-test target under the supplied rule.

### Why compare two versions?

A paired comparison demonstrates both rejection and acceptance behavior. It is more informative than showing only a successful policy check.

It also provides a basis for validating that the gate actually detects a version below the configured threshold.

### Container security considerations

- Prefer currently supported PHP releases.
- Use verified upstream image tags and inspect their resolved digests.
- Rebuild images regularly to receive current operating-system packages.
- Scan the final image rather than only scanning source files.
- Avoid embedding secrets in Dockerfiles or image layers.
- Run application containers as non-root where supported.
- Use read-only filesystems and restrictive capabilities when compatible with the application.
- Set CPU and memory limits at the container or orchestration layer.
- Review image provenance and dependency changes before release.

A patch-version check is one control within a broader container-security strategy; it is not a complete image-hardening assessment.

---

## 🛠️ Interim Runtime Mitigations

The repository includes the following PHP configuration file:

```text
docker/mitigations/php2shell-mitigation.ini
```

The supplied settings are:

```ini
memory_limit = -1
post_max_size = 8M
upload_max_filesize = 7M
session.upload_progress.enabled = 0
```

### Configuration review

| Setting | Intended effect | Security consideration |
|---|---|---|
| `memory_limit = -1` | Removes PHP's per-script memory limit | **Potentially unsafe.** A memory-exhaustion condition may consume substantially more memory. Prefer a finite, workload-tested limit for production. |
| `post_max_size = 8M` | Limits the maximum accepted POST body size at the PHP configuration layer | Can reduce exposure to oversized request bodies, but does not fix a parser vulnerability. |
| `upload_max_filesize = 7M` | Limits individual uploaded file size through PHP's upload configuration | Must be aligned with application requirements and upstream request limits. |
| `session.upload_progress.enabled = 0` | Disables PHP upload-progress tracking | Reduces exposure to unnecessary upload-progress functionality; it is not a general multipart-parser fix. |

### Recommended production posture

1. Apply a verified upstream security fix.
2. Use a supported PHP release and maintain it regularly.
3. Set a finite PHP memory limit based on workload testing.
4. Configure appropriate request-body limits at the reverse proxy, web server, and application layers.
5. Restrict request-processing time and container resource consumption.
6. Test multipart parsing and file-upload behavior using regression tests.
7. Monitor application errors, resource usage, and suspicious request patterns.

**Important:** These settings are interim defense-in-depth measures. They must not be presented as a replacement for a verified security patch. The effectiveness of each setting depends on the affected component, runtime configuration, and request-processing path.

---

## 🔎 Software Composition Analysis

PHP2Shell Sentinel uses **Aqua Security Trivy** to inspect container images for known vulnerabilities.

Trivy can identify applicable findings in operating-system packages and supported software components, depending on the image contents and scanner configuration.

### Scanner output

The workflow generates JSON reports that can be processed by subsequent pipeline stages.

Example local scan:

```bash
trivy image \
  --scanners vuln \
  --format json \
  --output trivy-report.json \
  php:8.3.36-fpm-alpine
```

The command above is an example of producing a vulnerability report; it does not by itself enforce a particular vulnerability policy.

### Recommended CI policy

For a production-oriented workflow:

- Define which vulnerability severities block a build.
- Decide how unfixed vulnerabilities are handled.
- Configure explicit failure conditions.
- Preserve the scanner's exit status.
- Record the scanner version and vulnerability-database update context.
- Review exceptions and document their expiry dates.
- Keep the raw JSON report as an audit artifact.

For example, a pipeline may block on selected high-severity findings:

```bash
trivy image \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  php:8.3.36-fpm-alpine
```

This command is an example of a possible enforcement policy, not a claim that every scanner invocation in the repository currently uses these exact flags.

### Scanner limitations

A clean report does not prove that a container is secure. Results depend on the scanner's coverage, vulnerability database, package metadata, image contents, and policy configuration.

Trivy image scanning should complement—not replace—runtime policy enforcement, application testing, and security review.

---

## 📊 Automated Reporting and Dashboard

The reporting stage uses:

```text
scripts/generate_report.py
```

The script aggregates available vulnerability findings into an HTML report suitable for publication.

The dashboard is hosted at:

**https://adilahamedwork-oss.github.io/php2shell-sentinel/**

### Reporting workflow

```text
Trivy JSON Reports
        |
        v
Python Report Generator
        |
        v
Finding Aggregation
        |
        v
HTML Audit Report
        |
        v
GitHub Pages Deployment
        |
        v
Public Audit Dashboard
```

### Benefits

- Centralized presentation of security findings.
- Easier review of results from multiple scan targets.
- A shareable artifact for portfolio demonstrations.
- A separation between machine-readable scan evidence and human-readable reporting.
- A repeatable way to communicate CI security results.

### Reporting requirements

For reliable reporting, the generator should:

- Validate input JSON before processing it.
- Handle missing or malformed reports explicitly.
- Preserve important vulnerability metadata.
- Escape untrusted text before embedding it in HTML.
- Distinguish an empty scan result from a scan that never ran.
- Avoid exposing credentials, internal URLs, environment variables, or sensitive infrastructure information.
- Record when the report was generated and which targets were scanned.
- Avoid presenting policy compliance as proof of complete security.

A generated dashboard is an audit artifact, not a substitute for the original scanner output or the CI execution logs.

---

## 📁 Repository Structure

The following is the intended logical structure based on the supplied project details. Confirm the actual filenames in GitHub if the implementation differs.

```text
php2shell-sentinel/
├── .github/
│   └── workflows/
│       └── ci.yml
├── docker/
│   └── mitigations/
│       └── php2shell-mitigation.ini
├── scripts/
│   ├── verify_policy.sh
│   └── generate_report.py
├── index.html
├── README.md
└── ...
```

### Directory responsibilities

| Path | Purpose |
|---|---|
| `.github/workflows/` | CI workflow definitions |
| `docker/mitigations/` | PHP runtime mitigation configuration |
| `scripts/verify_policy.sh` | Runtime version-policy enforcement |
| `scripts/generate_report.py` | JSON finding aggregation and HTML report generation |
| `index.html` | Dashboard entry point, if maintained as a repository source file |
| `README.md` | Project documentation |

Generated reports, image definitions, workflow filenames, and test scripts should be documented using their actual repository paths. The example tree above does not establish that every listed file currently exists.

---

## 💻 Prerequisites

To reproduce the lab locally, install:

- Git
- Docker Engine or Docker Desktop
- Bash
- PHP CLI, if running the policy script directly against the local runtime
- Python 3, for report-generation tasks
- Trivy, for local vulnerability scanning
- Internet access to retrieve container images and vulnerability metadata

The commands below assume a Bash-compatible terminal. On Windows, they can be run through an appropriate Linux environment or WSL. A Linux VM is also suitable if Docker is configured correctly.

---

## 🚀 Local Setup and Reproduction

### Step 1 — Clone the repository

```bash
git clone https://github.com/adilahamedwork-oss/php2shell-sentinel.git
cd php2shell-sentinel
```

### Step 2 — Verify the repository files

```bash
ls -la
find scripts docker -maxdepth 3 -type f
```

Confirm that the expected policy script and mitigation configuration are present.

### Step 3 — Check Docker

```bash
docker --version
docker info
```

If `docker info` fails, start Docker or configure access to the Docker daemon before continuing.

### Step 4 — Pull the comparison images

```bash
docker pull php:8.3.35-fpm-alpine
docker pull php:8.3.36-fpm-alpine
```

These commands retrieve the configured image tags. They do not independently prove that the images have a particular vulnerability status.

### Step 5 — Inspect the PHP runtime versions

```bash
docker run --rm \
  --entrypoint php \
  php:8.3.35-fpm-alpine \
  -r 'echo PHP_VERSION, PHP_EOL;'

docker run --rm \
  --entrypoint php \
  php:8.3.36-fpm-alpine \
  -r 'echo PHP_VERSION, PHP_EOL;'
```

The output identifies the PHP version reported by each image's interpreter.

### Step 6 — Run the policy script

```bash
chmod +x scripts/verify_policy.sh
./scripts/verify_policy.sh
```

**Important:** This command is appropriate only if the script evaluates the intended runtime and obtains its version from the expected environment. If the script reads the host's PHP CLI instead, the result may not represent either container.

For an accurate container assessment, the CI workflow or test harness should invoke the policy check inside the target image or pass a validated runtime-version value from that image.

The repository's actual script interface determines whether an image name, version, or other argument is required.

### Step 7 — Run a local Trivy scan

Install Trivy using its official installation instructions, then run:

```bash
trivy image \
  --scanners vuln \
  --format json \
  --output trivy-report.json \
  php:8.3.36-fpm-alpine
```

To scan the comparison target:

```bash
trivy image \
  --scanners vuln \
  --format json \
  --output trivy-report-vulnerable.json \
  php:8.3.35-fpm-alpine
```

The JSON files are produced in the current directory if the scan completes successfully. Findings depend on the image contents and the vulnerability database available at scan time.

### Step 8 — Generate the HTML report

The exact command depends on how `generate_report.py` accepts input and output paths.

Inspect its available arguments before running it:

```bash
python3 scripts/generate_report.py --help
```

If the script does not implement a `--help` interface, review its source to determine the expected arguments and input filenames.

### Step 9 — Review the live dashboard

Open:

https://adilahamedwork-oss.github.io/php2shell-sentinel/

The dashboard reflects whatever report was most recently published by the configured deployment workflow. Its existence does not guarantee that the latest workflow completed successfully.

---

## ✅ Expected Verification Results

Under the supplied PHP 8.3 threshold, the expected policy behavior is:

| Runtime version | Expected exit code | Interpretation |
|---|---:|---|
| `8.3.35` | `1` | Rejected by the configured policy |
| `8.3.36` | `0` | Accepted by the configured policy |

### Why the negative case is important

Security gates must demonstrate that they can reject a known noncompliant input. A script that always returns success is not a meaningful enforcement control.

### Why the positive case is important

The policy must also permit an input that meets the configured requirement. Otherwise, the gate could reject all inputs and still appear to block insecure versions.

### Recommended test matrix

A stronger implementation should test:

- A version below the threshold.
- The exact threshold version.
- A version above the threshold.
- A version from each supported PHP release branch.
- Malformed version output.
- An unsupported PHP release branch.
- A missing or failed runtime command.

This helps establish that the gate is deterministic, fail-closed, and not dependent on accidental string-comparison behavior.

---

## 🛡️ Core DevSecOps Controls

### Shift-left security

Security checks run during CI rather than relying exclusively on post-deployment discovery.

### Policy as code

The minimum runtime version is expressed as a version-controlled rule. Changes can be reviewed, tested, and audited alongside application code.

### Negative testing

The intentionally noncompliant target verifies that the enforcement logic rejects a policy violation.

### Positive testing

The compliant comparison target verifies that the gate can accept a permitted runtime.

### Software Composition Analysis

Trivy inspects container software components for known vulnerabilities and produces structured findings.

### Security evidence

JSON reports and generated HTML provide machine-readable and human-readable representations of the assessment.

### Automated delivery

GitHub Actions and GitHub Pages reduce manual effort in producing and publishing the dashboard.

### Defense in depth

Version enforcement, image scanning, runtime configuration, application testing, and deployment controls address different parts of the threat model.

### Fail-closed design

A missing version, invalid policy, or unexpected verification error should not silently be interpreted as a successful security check.

### Least privilege

CI workflows should use minimal token permissions and avoid unnecessary write access. Publishing should occur only in the job that requires it.

---

## 🧯 Failure Handling

A production-oriented pipeline should distinguish security rejection from technical failure.

| Condition | Recommended behavior |
|---|---|
| Runtime below minimum version | Fail the policy test |
| Runtime meets minimum version | Pass the policy test |
| PHP version command fails | Fail closed |
| Unsupported PHP branch | Fail closed unless explicitly approved |
| Trivy execution fails | Mark the scan as failed and preserve diagnostic output |
| Scanner reports blocking findings | Fail the security gate according to the defined policy |
| JSON report is malformed | Fail report processing rather than silently dropping findings |
| A scan report is missing | Report the missing scan; do not interpret it as zero vulnerabilities |
| HTML generation fails | Fail the report stage |
| GitHub Pages deployment fails | Report deployment failure and preserve prior published evidence where possible |

**A green CI status should mean that every required check passed**, not merely that the report generator completed.

---

## ⚠️ Limitations

PHP2Shell Sentinel is a security engineering lab and portfolio project. Its controls have a deliberately defined scope.

1. **Version compliance is not exploit validation.** A runtime version comparison does not prove whether a specific exploit works.
2. **Scanner coverage is not exhaustive.** Trivy can identify known vulnerabilities within its supported coverage, but cannot guarantee the absence of all vulnerabilities.
3. **Patch thresholds require maintenance.** Upstream advisories and supported-version policies change over time.
4. **Mitigations are context-dependent.** PHP configuration limits can reduce certain resource-exhaustion risks but do not replace a verified patch.
5. **CI enforcement depends on integration.** A failing script protects a deployment only if the workflow and deployment path require its successful completion.
6. **Public dashboards need review.** Reports must be checked for sensitive data before publication.
7. **Image tags are not immutable identities.** Stronger reproducibility requires recording image digests and relevant tool versions.
8. **The lab is not a full penetration test.** It does not establish comprehensive application security or production readiness.

---

## 🔭 Future Improvements

Potential enhancements for a more comprehensive DevSecOps implementation include:

- Add automated unit tests for the version-policy parser.
- Add an explicit integration test that evaluates each container's actual PHP runtime.
- Validate patch thresholds against authoritative advisories.
- Pin image digests and record software provenance.
- Introduce SBOM generation in CycloneDX or SPDX format.
- Add severity-based Trivy enforcement with documented exceptions.
- Add container image signing and signature verification.
- Integrate SARIF output with GitHub code-scanning workflows where appropriate.
- Add automated tests for missing, malformed, and stale reports.
- Add report timestamps and scanner-database metadata.
- Introduce scheduled vulnerability scans.
- Add branch protection and required status checks.
- Harden the GitHub Actions workflow using least-privilege permissions.
- Use finite PHP memory limits and test request-size controls.
- Add regression tests for multipart request handling.
- Add a deployment approval stage for production environments.
- Track remediation status and the age of unresolved findings.
- Add report sanitization tests before publishing to GitHub Pages.

These enhancements would help evolve the lab from a demonstration of core security concepts into a more comprehensive security-assurance workflow.

---

## 📚 Learning Outcomes

This project demonstrates practical experience with:

- DevSecOps pipeline design.
- GitHub Actions CI/CD automation.
- Docker image management and runtime inspection.
- PHP runtime-version verification.
- Deterministic security-policy enforcement.
- Negative and positive security testing.
- Software Composition Analysis with Trivy.
- JSON report processing.
- Python-based HTML report generation.
- GitHub Pages publishing.
- Runtime configuration and defense in depth.
- Threat modeling and security-control documentation.
- Vulnerability reporting and remediation workflows.

It also highlights an important engineering principle: **a security control should be tested for both its ability to reject unsafe inputs and its ability to accept compliant inputs.**

---

## 🔗 References

Use authoritative sources when validating vulnerability information and implementing the controls described in this repository.

- **PHP official website:** https://www.php.net/
- **PHP supported versions:** https://www.php.net/supported-versions.php
- **PHP security advisories:** https://www.php.net/archive/
- **National Vulnerability Database:** https://nvd.nist.gov/
- **CVE Program:** https://www.cve.org/
- **Trivy documentation:** https://trivy.dev/
- **Docker documentation:** https://docs.docker.com/
- **GitHub Actions documentation:** https://docs.github.com/en/actions
- **GitHub Pages documentation:** https://docs.github.com/en/pages

Before treating the supplied CVE identifiers, severity score, affected releases, or patch thresholds as authoritative, verify them against the corresponding official records.

---

## 👨‍💻 Author

**Adil ahamed B**

Aspiring Cloud Security / DevSecOps Engineer

Interested in cloud security, container security, vulnerability management, and automated security controls.

- **GitHub repository:** https://github.com/adilahamedwork-oss/php2shell-sentinel
- **Live audit dashboard:** https://adilahamedwork-oss.github.io/php2shell-sentinel/
- **Portfolio:** https://adil-ahamed-b.vercel.app/

---

## ⚖️ Disclaimer

PHP2Shell Sentinel is intended for educational, defensive security research and authorized testing.

The project illustrates runtime-version policy enforcement, container vulnerability scanning, report aggregation, and security-dashboard publication. It should not be interpreted as proof that any particular vulnerability is exploitable, that a given image is definitively vulnerable or remediated, or that a production system is secure.

Verify vulnerability details, upstream security advisories, image provenance, and remediation requirements before using the project as part of a production security process.

Use security testing tools only on systems and environments you own or are explicitly authorized to assess.

---

<p align="center">
  <strong>PHP2Shell Sentinel</strong><br>
  <em>Detect. Verify. Enforce. Report.</em>
</p>
