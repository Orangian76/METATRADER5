---
name: CrossBrokerPriceMonitor feature request
about: Suggest an improvement while keeping quote monitoring separate from trade execution
title: "[CrossBroker Feature] "
labels: ""
assignees: "Orangian76"
---

## Requested capability

Describe the proposed feature.

## Use case

Explain the practical problem it solves.

## Component

- [ ] MQL5 Agent
- [ ] C# Coordinator
- [ ] TCP protocol
- [ ] CSV/data export
- [ ] User interface
- [ ] Documentation
- [ ] CI/release process

## Proposed behavior

Describe inputs, outputs, configuration, and expected failure handling.

## Safety impact

- [ ] Quote monitoring only
- [ ] Changes network exposure
- [ ] Handles sensitive data
- [ ] Introduces or affects trade execution

Any feature involving order placement must be isolated, disabled by default, separately reviewed, and must not change the quote-only behavior of version 1.x.

## Alternatives considered

Describe simpler approaches or workarounds.
