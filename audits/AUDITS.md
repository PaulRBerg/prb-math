# Track Record of Audits

The PRBMath library was included in the Sablier codebase audited by the [Cantina](https://cantina.xyz/welcome) team during May-June of 2023. Likewise, the [Certora](https://medium.com/certora/problems-in-solidity-fixed-point-libraries-certora-bug-disclosure-987f504daca4) team identified a design flaw in July of 2023. Both issues were timely addressed and are now fixed.

## Cantina Review

In June-2023, the team realized a security review of `Sablier v1.0.0`, which included `prb-math@v3.3.3"` in the scope. The report of the review included a finding for the PRBMath library, "3.2.3 PRBMath pow() function can return inconsistent values."

### PRBMath pow() function can return inconsistent values

_Full report_: [cantina-2023-06-08.pdf](https://github.com/sablier-labs/audits/blob/6567df3fa42b90663e3e694b1e776c6db337a3f2/v2-core/cantina-2023-06-08.pdf)

_PRBMath reviewed version_: [prb-math@v3.3.3](https://github.com/PaulRBerg/prb-math/tree/v3.3.2)

_Severity_: High Risk

_Context_: [sd59x18/Math.sol#L596-L609](https://github.com/PaulRBerg/prb-math/blob/df27d3d12ce12153fb166e1e310c8351210dc7ba/src/sd59x18/Math.sol#L596-L609) 

_Description_: 
> PRBMath's pow() function takes in two signed integers, `x` and `y`, and returns `x ** y`
> 
> A proper implementation of the pow() function should uphold the following invariant:
>
> `If x >= y and a >= 0, then x ** a >= y ** a.`
>
> This is a crucial invariant for the Sablier protocol, because the pow() function is used by SablierV2LockupDynamic.sol to compute total streamed amounts based on the current time. It is required for the protocol to function as expected that, as block.timestamp increases, the total streamed amount increases as well. Implications of this issue are addressed in C-01 of this report.
 
Status: Fixed in https://github.com/PaulRBerg/prb-math/pull/179, which was included in release https://github.com/PaulRBerg/prb-math/releases/tag/v4.0.0
