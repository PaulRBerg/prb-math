# Security Review History for PRBMath

| :warning: | Audits are not a guarantee of correctness. Some parts of the code base were modified after they were audited. |
| --------- | :------------------------------------------------------------------------------------------------------------ |

The PRBMath library was included in the Sablier codebase audited by the [Cantina](https://cantina.xyz/welcome) team during May-June of 2023. Likewise, the [Certora](https://medium.com/certora/problems-in-solidity-fixed-point-libraries-certora-bug-disclosure-987f504daca4) team identified a design flaw in April of 2023. Both issues were timely addressed and are now fixed.

| Auditor           | Type    | Initial Commit       | Report                                         |
| :---------------- | :------ | :------------------- | :--------------------------------------------- |
| Cantina           | Firm    | [prb-math@v3.3.3](https://github.com/PaulRBerg/prb-math/tree/v3.3.2) | [2023-06-08](https://github.com/sablier-labs/audits/blob/6567df3fa42b90663e3e694b1e776c6db337a3f2/v2-core/cantina-2023-06-08.pdf) |
| Certora           | Firm    | [prb-math@v4.0.0](https://github.com/PaulRBerg/prb-math/tree/v4.0.0) | [2023-07-12](https://medium.com/certora/problems-in-solidity-fixed-point-libraries-certora-bug-disclosure-987f504daca4)     |

## Cantina Review

In May-June of 2023, the team realized a security review of `Sablier v1.0.0`, which included `prb-math@v3.3.3` in the scope. The report of the review included a finding for the PRBMath library: "3.2.3 PRBMath pow() function can return inconsistent values."

### Issue: PRBMath pow() function can return inconsistent values

- _Full report_: [cantina-2023-06-08.pdf](https://github.com/sablier-labs/audits/blob/6567df3fa42b90663e3e694b1e776c6db337a3f2/v2-core/cantina-2023-06-08.pdf)
- _PRBMath version_: [prb-math@v3.3.3](https://github.com/PaulRBerg/prb-math/tree/v3.3.2)
- _Severity_: High Risk
- _Context_: [sd59x18/Math.sol#L596-L609](https://github.com/PaulRBerg/prb-math/blob/df27d3d12ce12153fb166e1e310c8351210dc7ba/src/sd59x18/Math.sol#L596-L609)
- _Status_: `Fixed` in https://github.com/PaulRBerg/prb-math/pull/179, which was included in release https://github.com/PaulRBerg/prb-math/releases/tag/v4.0.0

## Certora Review

In April of 2023, the team reported a security bug in `prb-math@v4.0.0`, the discussion of which was tracked in https://github.com/PaulRBerg/prb-math/discussions/186

### Issue: Wrong rounding direction for negative numbers

- _Full Analysis_: [Problems in Solidity Fixed Point Libraries — Certora Bug Disclosure](https://medium.com/certora/problems-in-solidity-fixed-point-libraries-certora-bug-disclosure-987f504daca4)
- _PRBMath version_: [prb-math@v4.0.0](https://github.com/PaulRBerg/prb-math/tree/v4.0.0)
- _Severity_: Not clear, potentially Critical/High
- _Context_: [src/Common.sol#L387](https://github.com/PaulRBerg/prb-math/blob/7ce3009bbfa0d8e2d430b7a1a9ca46b6e706d90d/src/Common.sol#L387)
- _Status_: `Mitigated` with "Clarify rounding modes" in release https://github.com/PaulRBerg/prb-math/releases/tag/v4.0.1
