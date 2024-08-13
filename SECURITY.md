# Security

The PRBMath codebase has undergone audits by leading security experts from Cantina and Certora.

| :warning: | Audits are not a guarantee of correctness. Some parts of the code base were modified after they were audited. |
| --------- | :------------------------------------------------------------------------------------------------------------ |

All issues have been timely addressed and are fixed in the latest version of PRBMath.

| Auditor | Type | Initial Commit                                                       | Report                                                                                                                            |
| :------ | :--- | :------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------- |
| Certora | Firm | [prb-math@v4.0.0](https://github.com/PaulRBerg/prb-math/tree/v4.0.0) | [2023-07-12](https://medium.com/certora/problems-in-solidity-fixed-point-libraries-certora-bug-disclosure-987f504daca4)           |
| Cantina | Firm | [prb-math@v3.3.3](https://github.com/PaulRBerg/prb-math/tree/v3.3.2) | [2023-06-08](https://github.com/sablier-labs/audits/blob/6567df3fa42b90663e3e694b1e776c6db337a3f2/v2-core/cantina-2023-06-08.pdf) |

## Cantina Review

Cantina performed an audit of [Sablier Lockup](https://github.com/sablier-labs/v2-core) in June 2023, which included `prb-math@v3.3.3` in scope. Their
report included a finding in PRBMath:

> 3.2.3 PRBMath pow() function can return inconsistent values

The issue has been fixed in this PR: https://github.com/PaulRBerg/prb-math/pull/179

## Certora Review

The rounding modes were not explicitly documented. This issue was fixed in [v4.0.1](https://github.com/PaulRBerg/prb-math/releases/tag/v4.0.1).
