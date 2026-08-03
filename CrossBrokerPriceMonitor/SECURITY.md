# Security Policy

## Supported versions

Security fixes are currently applied to the latest version on the `main` branch.

| Version | Supported |
|---|---|
| 1.x | Yes |
| < 1.0 | No |

## Reporting a vulnerability

Please do not publish sensitive vulnerabilities, broker credentials, account details, private network information, or exploitable proof-of-concept code in a public issue.

Report the problem privately to the repository owner through GitHub's available private contact or security reporting mechanisms. Include:

- A clear description of the issue
- Affected files and versions
- Reproduction steps
- Expected and actual behavior
- Potential impact
- Suggested mitigation, if available

## Security model

This project is designed as a local monitoring tool.

- The coordinator should bind to `127.0.0.1` only.
- Agents and coordinator should run on the same trusted Windows machine or VPS.
- The TCP protocol has no encryption or authentication because it is intended for loopback use only.
- Do not expose the coordinator port to public or untrusted networks.
- Do not modify the binding to `0.0.0.0` without adding authentication, encryption, access controls, rate limits, and input hardening.

## Sensitive data

Never commit:

- Broker usernames or passwords
- Trading account numbers
- Investor passwords
- VPS credentials
- API keys or tokens
- Private broker server details
- Unredacted production logs containing personal or account information

## Trading safety

The current project does not place, modify, or close orders. Any contribution that introduces trade execution materially changes the risk profile and requires a separate threat model, explicit safeguards, independent testing, and clear user consent.

## Scope limitations

A positive cross-broker quote difference is not proof of executable profit. Security and operational risks include stale quotes, spoofed local input, malformed messages, clock drift, process compromise, broker feed differences, and misleading logs.
