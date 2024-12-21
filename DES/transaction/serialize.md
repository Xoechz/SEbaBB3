# Serialisierung

| u | x | y | z |
|---|---|---|---|
| r4 | r2 | w4 | r1 |
| r3 | w4 | r5 | w2 |
| | | | r3 |

:::mermaid
flowchart LR
T1 -- rw z --> T2;
T2 -- wr z --> T3;
T2 -- rw x --> T4;
T4 -- wr y --> T5;
:::

Mögliche Ausführungen:

1 - 2 - 3 - 4 - 5
1 - 2 - 4 - 5 - 3
1 - 2 - 4 - 3 - 5

t2 w auf y bricht die Serialisierbarkeit
