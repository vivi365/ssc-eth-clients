# Attack Vectors Design

## Exclusion Criteria

- C1: No viable mitigative measures
- C2: too fine grained (use parent node, child nodes may be discussed as motivation of parent)
- C3: Overarching parent branch vector

## Mappings

Affect one of the following

- Source (S)
- Build (B)
- Dependency (D)
- Package (P)

## Analysis

### 1. Develop and Advertise Distinct Malicious Package from Scratch

- AV-100: Develop and Advertise Distinct Malicious Package from Scratch
  - AFFECTS
    - D
- NEW NAME
  - "Malicious Package Advertisement"

## 2. Create Name Confusion with Legitimate Package

- AV-200 Create Name Confusion with Legitimate Package
  - AFFECTS
    - D, P
  - NEW NAME
    - Name Confusion with Legitimate Package
  - CHILD EXCLUSIONS
    - AV-201-209 (C2)

## 3. Subvert Legitimate Package

- EXCLUSIONS
  - AV-001 Subvert Legitimate Package (C3)

### 3.1 Inject Into Sources of Legitimate Package

- EXCLUSIONS

- AV-300 Inject Into Sources of Legitimate Package (C3)

- AV-301: Introduce Malicious Code through Hypocrite Merge Request

  - AFFECTS
    - S, D
  - NEW NAME
    - Malicious Code in Hypocrite Merge Request
  - CHILD EXCLUSIONS
    - AV-304 (C2)
    - Av-305-309 (C2)

- AV-302 Contribute as Maintainer

  - AFFECTS
    - S
  - NEW NAME
    - Merge Malicious Code through Maintainer Access
  - CHILD EXCLUSIONS
    - AV-601-608 (C2)
    - AV-800-801 (C1)
    - AV-700-702 (C2)

- AV-303 Tamper with Version Control System
  - AFFECTS
    - S
  - NEW NAME
    - Exploit Vulnerability in VCS
  - CHILD EXCLUSIONS
    - AV-600 (C2)
    - AV-601-608 (C2)
    - AV-700-702 (C2)

### 3.2 Inject During the Build of Legitimate Package

- EXCLUSIONS

  - AV-400 Inject During the Build of Legitimate Package (C3)

- AV-401 Run Malicious Build

  - AFFECTS
    - B
  - NEW NAME
    - Shared Resource Build Exploit

- AV-402 Tamper Build Job as Maintainer

  - AFFECTS
    - B
  - NEW NAME
    - Tamper with Build through Maintainer Access
  - CHILD EXCLUSIONS
    - AV-601-608 (C2)
    - AV-800-801 (C1)
    - AV-700-702 (C2)

- AV-403 Tamper with Exposed Build System
  - AFFECTS
    - B
  - NEW NAME
    - Exploit Vulnerability in Build System
  - CHILD EXCLUSIONS
    - AV-600 (C2)
    - AV-601-608 (C2)
    - AV-700-702 (C2)

### 3.3 Distribute Malicious Version of Legitimate Package

- EXCLUSIONS

  - AV-500 Distribute Malicious Version of Legitimate Package (C3)

- AV-501 Danging Reference
  - AFFECTS
    - D
- AV-502 Mask legitimate package
  - AFFECTS
    - P
- CHILD EXCLUSIONS

  - AV-506-509 (C2)

- AV-503 Prevent Update to Non-Vulnerable Version

  - AFFECTS
    - P
  - NOTE
    - yes! attack to the website eg.
    - Affects D through delayed indexing?

- AV-504 Distribute as Package Maintainer

  - AFFECTS
    - P
  - NEW NAME
    - Distribute Malicious Package Version through Maintainer Access
  - CHILD EXCLUSIONS
    - AV-601-608 (C2)
    - AV-800-801 (C1)
    - AV-700-702 (C2)

- AV-505 Inject into Hosting System
  - AFFECTS
    - P
  - NEW NAME
    - Exploit Vulnerability in Hosting (specific?) System
  - CHILD EXCLUSIONS
    - AV-600 (C2)
    - AV-601-608 (C2)
    - AV-700-702 (C2)
